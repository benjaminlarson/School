\documentclass[14pt]{beamer}

\usepackage[scaled=0.85]{helvet}

\usepackage{tikz}
\usetikzlibrary{calc}

\usecolortheme{orchid}
\useinnertheme[shadow]{rounded}
\setbeamertemplate{items}[default]

\usefonttheme[onlymath]{serif}
\setbeamertemplate{navigation symbols}{}
\setbeamerfont{smallfont}{size=\small}

\title{Model Selection: Information Criteria and Sparsity Approaches}
\author{CS 6190: Probabilistic Modeling}


\date{March 3, 2016}

\setbeamertemplate{footline}[frame number]

\begin{document}

<<setup, echo=FALSE, message=FALSE>>=
  require(knitr)
require(nlme)
require(FindMinIC)
require(AdaptiveSparsity)

## Set some options
opts_chunk$set(fig.align='center',fig.show='hold',out.width="0.6\\textwidth",
               size='footnotesize',comment=NA,prompt=TRUE)
options(digits = 4)

## Read in the cross-sectional OASIS data, including hippocampal volumes
x = read.csv("oasis_cross-sectional.csv")
y = read.csv("oasis_hippocampus.csv")
cdat = merge(x, y, by = "ID")

## Let's look at only elderly subjects
cdat = cdat[cdat$Age >= 60,]
rownames(cdat) = NULL

## Remove columns we won't need
cdat = cdat[ , !(names(cdat) %in% c("Delay", "Hand", "SES", "Educ", "ASF"))]
@
  
  \frame{
    \vspace*{24pt}
    \maketitle
  }

\frame{
  \frametitle{Linear Model Selection}
  {\bf Linear Model:}
  \begin{align*}
  y &= X\beta + \epsilon\\
  &= \beta_0 + x_1 \beta_1 + x_2 \beta_2 + \ldots + x_K \beta_K + \epsilon\\
  &\\
  \epsilon &\sim N(0, \sigma^2)\\
  \end{align*}
  
  \uncover<2->
  {
    {\bf Model Selection Problem:}\\
    Which regressors, $x_i$, should we include in the model?
  }
}

\begin{frame}[fragile]
\frametitle{OASIS Brain Data}

{\small \url{http://www.oasis-brains.org}}

<<eval=TRUE>>=
  head(cdat[,-1])
@
  
  \begin{minipage}[t][2in]{\textwidth}

\only<1>{
  {\tt MMSE}: Mini-Mental State Exam\\
  {\tt CDR }: Clinical Dementia Rating\\
  {\tt eTIV}: Estimated Total Intracranial Volume\\
  {\tt nWBV}: Normalized Whole Brain Volume\\
}

\only<2-3>{
  {\bf Hypotheses of interest:}
  \begin{itemize}
  \item<2-> Hippocampal volume decreases with age
  \item<3-> Lower hippocampal volume is also associate with cognitive decline (as measured by MMSE, CDR)
  \end{itemize}
}

\only<4>{
  {\bf What models do we use to test these hypotheses?}
  \begin{itemize}
  \item Should we include all variables simultaneously (Age, MMSE, CDR)?
  \item Which covariates should we include (M.F, eTIV, nWBV)?\\
  \end{itemize}
}
\end{minipage}

\end{frame}

\begin{frame}
\vspace*{24pt}

\large{\it All models are wrong, but some are useful.}\\
\vspace*{24pt}

\hfill {--- George Box}
\end{frame}

\begin{frame}
\large{\bf Why not include all the variables we have?}\\

\uncover<2>{
  \begin{enumerate}
  \item Danger of overfitting
  \item Each parameter we estimate requires more data
  \end{enumerate}
}
\end{frame}

\begin{frame}
\large{\bf Why not just include covariates that have a ``significant'' effect in the
  linear model?}\\
\vspace*{24pt}

\uncover<2>{Let's see!}
  
  \end{frame}
  
  \begin{frame}[fragile]
  \frametitle{Age Effects Only}
  
  <<eval=TRUE>>=
  g1 = lm(RightHippoVol ~ Age, data = cdat)
  coef(summary(g1))
  @
  
  \visible<2>
  {
  \tikz[remember picture,overlay] {%
  \draw[ultra thick, blue, rounded corners]
  (7.25, 1.05) rectangle (9.25, 1.5);
  }\\
  \textcolor{blue}{\noindent Age effect is significant}
  }
  \end{frame}
  
  \begin{frame}[fragile]
  \frametitle{Age Effects Only}
  <<eval=TRUE>>=
  plot(RightHippoVol ~ Age, data = cdat, lwd = 3)
  abline(g1, col = 'red', lwd = 4)
  @
  \end{frame}
  
  \begin{frame}[fragile]
  \frametitle{Adding Sex Covariate}
  <<eval=TRUE>>=
  g2 = lm(RightHippoVol ~ Age + M.F, data = cdat)
  coef(summary(g2))
  @
  
  \visible<2>{
  \tikz[remember picture,overlay] {%
  \draw[ultra thick, blue, rounded corners]
  (7.25, 1) rectangle (9.25, 1.45);
  \draw[ultra thick, blue, rounded corners]
  (7.25, 1.45) rectangle (9.25, 1.9);
  }\\
  \textcolor{blue}{Age effect is significant\\
  Sex effect is significant}
  }
  \end{frame}
  
  \begin{frame}[fragile]
  \frametitle{Adding Brain Volume Covariate}
  <<eval=TRUE>>=
  g3 = lm(RightHippoVol ~ Age + M.F + nWBV, data = cdat)
  coef(summary(g3))
  @
  
  \visible<2>{
  \tikz[remember picture,overlay] {%
  \draw[ultra thick, blue, rounded corners]
  (7.25, 1) rectangle (9.25, 1.45);
  \draw[ultra thick, blue, rounded corners]
  (7.25, 1.45) rectangle (9.25, 1.9);
  \draw[ultra thick, red, rounded corners]
  (7.25, 1.9) rectangle (9.25, 2.3);
  }\\
  \textcolor{red}{Age effect is NOT significant\\}
  \textcolor{blue}{Sex effect is significant\\
  Whole brain volume effect is significant}
  }
  
  \end{frame}
  
  \begin{frame}[fragile]
  \frametitle{Adding Clinical Dementia Rating}
  <<eval=TRUE>>=
  g4 = lm(RightHippoVol ~ Age + M.F + nWBV + CDR, data = cdat)
  coef(summary(g4))
  @
  
  \visible<2>{
  \tikz[remember picture,overlay] {%
  \draw[ultra thick, blue, rounded corners]
  (7.25, 1) rectangle (9.25, 1.45);
  \draw[ultra thick, blue, rounded corners]
  (7.25, 1.45) rectangle (9.25, 1.9);
  \draw[ultra thick, blue, rounded corners]
  (7.25, 1.9) rectangle (9.25, 2.3);
  \draw[ultra thick, blue, rounded corners]
  (7.25, 2.3) rectangle (9.25, 2.7);
  }\\
  \textcolor{blue}{Everything is significant!}
  }
  
  \end{frame}
  
  \frame{
  \frametitle{Summary}
  \begin{itemize}
  \item<1-> Can't choose models based on $p$-values!
    \item<2-> Statistical significance can be manipulated by inclusion/exclusion of
  covariates
  \item<3-> Need a systematic and automatic method for selecting models
  \item<4-> Included variables and model selection procedure should be decided before analysis
  \end{itemize}
  }

\begin{frame}[fragile]
\frametitle{Highest $R^2$ or Likelihood?}
<<eval=TRUE,echo=FALSE>>=
  models = list(g1, g2, g3, g4)
r2 = sapply(models, function(g) { summary(g)$r.squared })
plot(1:4, r2, xlab = "Model", ylab = expression(R^2), lwd = 4, type = 'b',
     xaxt = 'n', main = expression(paste(R^2, " as Model Complexity Increases")),
     cex.lab = 1.5, cex.main = 1.5)
axis(1, at = 1:4)
@
  
  \visible<2>{\bf $R^2$ always increases when you add covariates}
\end{frame}

\frame{
  \frametitle{Occam's Razor}
    \large{\bf Choose the simplest model that explains your data, i.e., the fewest parameters.}
  }
    
    \frame{
    \frametitle{Akaike Information Criteria\footnote{Akaike, IEEE TAC, 1974}}
    Pick the model that minimizes
    $$\mathrm{AIC} = 2k - 2 \ln (L)$$
    
    $k$: number of parameters\\
    $L$: log-likelihood\\
    \vspace*{12pt}
    
    \visible<2>{
    Tradeoff between
    \begin{center}
    {\bf maximizing} likelihood\\ and\\ {\bf minimizing} number of parameters}
    \end{center}
    }
    
    \frame{
    \frametitle{AIC Under Gaussian Likelihood}
    If the model has normally-distributed errors,
    \begin{align*}
    \mathrm{AIC} &= 2k - 2 \ln (L)\\
    &= 2k + n \ln\left(\frac{1}{n} \sum_{i = 1}^n \hat{\epsilon_i}^2 \right)
    \end{align*}
    
    $\hat{\epsilon_i}$: estimated residual of $i$th data point
    }
    
    \frame{
    \frametitle{Motivation of AIC}
    \begin{itemize}
    \item<1-> We want the best approximation of some ``true'' density $f(x)$.
    \item<1-> Given candidate models: $g_i(x | \theta_i)$
    \item<2-> Minimize the Kullback-Leibler divergence:
    \end{itemize}
    \begin{align*}
    K(f, g_i) = \int f(x) \ln f(x) dx - \int f(x) \ln g_i(x | \theta_i) dx
    \end{align*}
    \begin{itemize}
    \item<3-> AIC approximates this KL divergence (up to a constant in $g_i$)
    \end{itemize}
    }
    
    \frame{
    \frametitle{AICc: Bias-corrected AIC}
    \begin{itemize}
    \item<1-> AIC has a first-order correction for bias
    \item<2-> The bias can still be significant for small $n$
    \item<3-> A second-order correction of the bias gives:
    $$\mathrm{AICc} = \mathrm{AIC} + \frac{2k(k + 1)}{n - k - 1}$$
    \end{itemize}
    }
    
    \frame{
    \frametitle{Nice Review Article on AIC}
    Burnham, K. P.; Anderson, D. R. (2004), ``Multimodel inference:
    understanding AIC and BIC in Model Selection'', Sociological
    Methods and Research 33: 261-304.
    }
    
    \begin{frame}[fragile]
    \frametitle{R Package: {\tt FindMinIC}}
    Install from CRAN:
    <<echo=TRUE,eval=FALSE>>=
    install.packages("FindMinIC")
    @
    \begin{itemize}
    \item Tests all $2^K$ possible subsets of $K$ regressors
    \item Ranks them based on AIC (or AICc, or BIC)
    \item Regressors can be fixed to always be included
    \end{itemize}
    \end{frame}
    
    \begin{frame}[fragile]
    \frametitle{OASIS Example Revisited}
    <<echo=TRUE,tidy=FALSE>>=
    aicModels = FindMinIC(
    RightHippoVol ~ Age + CDR + MMSE + M.F + nWBV + eTIV,
    data = cdat)
    print(summary(aicModels)$table[1:5,])
    @
    \end{frame}
    
    \begin{frame}[fragile]
    \frametitle{OASIS Example Revisited}
    <<echo=FALSE>>=
    opts_chunk$set(size = "tiny")
    @
    <<echo=TRUE,tidy=FALSE>>=
    summary(getFirstModel(aicModels))
    @
    <<echo=FALSE>>=
    opts_chunk$set(size = "footnotesize")
    @
    \end{frame}
    
    \frame{
    \frametitle{Model Selection via Sparsity}
    \begin{itemize}
    \item Idea: force coefficients to zero by penalizing non-zero entries
    \item Sparse approximation:
    $$\hat{\beta} = \arg \min_{\beta} \|y - X\beta\|^2 + \lambda \|\beta\|_0.$$
    Using $l_0$ norm:
    $$\|\beta\|_0 = \text{``number of non-zero elements of $\beta$''}$$
    \item This is an NP-hard optimization problem
    \end{itemize}
    }
    
    \frame{
    \frametitle{The lasso\footnote{{\it Tibshirani,  {\it J. Royal. Statist. Soc B.}, 1996}}}
    \begin{itemize}
    \item The $l_1$ norm is a convex relaxation of the $l_0$ norm:
    $$\|\beta\|_1 = \sum_{i=1}^K |\beta_i|$$
    \item The lasso estimator is
    $$\hat{\beta} = \arg \min_{\beta} \|y - X\beta\|^2 + \lambda \|\beta\|_1$$
    \item This is now a convex optimization problem
    \end{itemize}
    }
    
    \frame{
    \frametitle{Adaptive Sparsity\footnote{{\it Figueiredo, PAMI 2003}}}
    \begin{itemize}
    \item<1-> Hierarchical prior on $\beta$:
    \begin{align*}
    \beta &\sim N(0, \tau)\\
    \tau &\propto \frac{1}{\tau}
    \end{align*}
    \item<2-> Parameter-free Jeffreys' hyperprior on $\tau$
      \item<3-> MAP estimation of $\beta$ by EM algorithm
    \item<4-> After marginalizing $\tau$, equivalent to a log penalty:
      $$\log p(\beta) \propto \log(|\beta| + \delta) - \log(\delta)$$
      (Need the $\delta > 0$ fudge factor for numerics)
    \end{itemize}
    }
  
  \begin{frame}[fragile]
  \frametitle{Comparison of Penalty Functions}
  <<echo=FALSE, eval=TRUE>>=
    t = seq(-2, 2, 0.01)
    plot(0, 0, pch = 19, xlab = expression(beta), ylab = "Penalty",
         cex = 2, ylim = c(-0.5, 2), xlim = c(-2, 2), cex.lab = 1.5)
    points(0, 1, cex = 2)
    lines(c(-2, -0.05), c(1, 1), lwd = 3)
    lines(c(0.05, 2), c(1, 1), lwd = 3)
    abline(0, 0, lty = 2, col = "grey")
    lines(c(0, 0), c(-0.5, 2), lty = 2, col = "grey")
    
    lines(t, abs(t), lwd = 3, col = 'red')
    
    lines(t, (1/15) * (log(abs(t) + 1e-6) - log(1e-6)), lwd = 3, col = 'blue')
    
    legend("bottomleft", c("L0", "L1", "Log"), lwd = 3, col = c("black", "red", "blue"))
    @
      \end{frame}
    
    \frame{
      \frametitle{R Package: {\tt AdaptiveSparsity}}
      Install from CRAN:
        <<eval=FALSE>>=
        install.packages(AdaptiveSparsity)
      @
        
        \begin{itemize}
      \item Implements Figueiredo's adaptively sparse linear regression ({\tt aslm})
      \item Also has a method for estimating sparse Gaussian graphical models ({\tt
      asggm})\footnote{{\it Wong, Awate, Fletcher, ICML 2013}}
      \end{itemize}
    }
      
      \begin{frame}[fragile]
      \frametitle{OASIS Example Re-Revisited}
      <<eval=TRUE, tidy=FALSE>>=
      g = aslm(
      RightHippoVol ~ Age + CDR + MMSE + M.F + nWBV + eTIV,
      data = cdat)
      as.matrix(coef(g))
      @
      
      \uncover<2>{
      {\bf Same coefficients chosen by AIC!}
      }
      \end{frame}
      
      \begin{frame}
      \frametitle{An Interesting Connection}
      \begin{center}
      Sparse approximation is {\bf equivalent} to AIC!
      \end{center}
      \uncover<2->
      {
      \begin{align*}
      \uncover<2->{
      \hat{\beta} &= \arg \min_{\beta} \|y - X\beta\|^2 + \lambda \|\beta\|_0 & \\}
      \uncover<3->{
      &= \arg \min_{k, \|\beta\|_0 = k} -2 \ln L(\beta | y) + 2k,
      & \text{(setting $\lambda = 2$)}\\}
      \uncover<4->{
      &= \arg \min_{k, \|\beta\|_0 = k} \mathrm{AIC}(\beta) & \\}
      \end{align*}
      }
      \end{frame}
      
      \begin{frame}
      \frametitle{Polynomial Regression Example Revisited}
      <<echo=FALSE>>=
      ## Sample size
      n = 30
      
      ## True regression coefficients (beta0 + beta1 * x + beta2 * x^2 + ...)
      trueBeta = c(1, -3, 0, 5, 0, 0, 0, 0, 0, 0, 0)
      d = length(trueBeta)
      
      ## Generate some random x values and the X data matrix
      a = -2
      b = 2
      x = runif(n, a, b)
      X = cbind(rep(1, n), x, x^2, x^3, x^4, x^5, x^6, x^7, x^8, x^9, x^10)
      
      ## Generate dependent variable: y = X * beta + noise
      sigma = 10
      eps = rnorm(n, mean = 0, sd = sigma)
      y = X %*% trueBeta + eps
      
      ## Plot everything
      ## Plotting variable (x-axis)
      t = seq(a, b, 0.01)
      m = length(t)
      T = cbind(rep(1, m), t, t^2, t^3, t^4, t^5, t^6, t^7, t^8, t^9, t^10)
      
      plot(x, y, xlim = c(a,b), ylim = range(y, T%*%trueBeta),
      main = "Simulated Input Data")
      @
      \end{frame}
      
      \begin{frame}
      \frametitle{Ordinary Least Squares}
      <<echo=FALSE>>=
      betaHat = as.vector(solve(t(X) %*% X, t(X) %*% y))
      
      plot(x, y, xlim = c(a,b), ylim = range(y, T%*%trueBeta),
      main = "OLS Regression")
      lines(t, T %*% trueBeta, col='red', lwd=3)
      lines(t, T %*% betaHat, col='blue', lwd=3)
      legend("topleft", c("True f(x)", "10th-order OLS"),
      col = c("red", "blue"), lwd=3)
      @
      \end{frame}
      
      \begin{frame}
      \frametitle{Bayesian (Ridge) Regression}
      <<echo=FALSE>>=
      lambda = 0.1
      Lambda = diag(lambda, d, d)
      
      SigmaPost = sigma^2 * solve(t(X) %*% X + sigma^2 * Lambda)
      betaPost = sigma^(-2) * as.vector(SigmaPost %*% (t(X) %*% y))
      
      plot(x, y, xlim = c(a,b), ylim = range(y, T%*%trueBeta),
      main = "Bayesian Regression")
      lines(t, T %*% trueBeta, col='red', lwd=3)
      lines(t, T %*% betaPost, col='blue', lwd=3)
      legend("topleft", c("True f(x)", "OLS Estimate", "Bayesian Regression"),
      col = c("red", "blue", "magenta"), lwd=3)
      @
      \end{frame}
      
      \begin{frame}
      \frametitle{Adaptive Sparse Regression}
      <<echo=FALSE>>=
      betaSparse = as.numeric(aslm(X, y)$coefficients)
      
      plot(x, y, xlim = c(a,b), ylim = range(y, T%*%trueBeta),
      main = "Adaptive Sparse Regression")
      lines(t, T %*% trueBeta, col='red', lwd=3)
      lines(t, T %*% betaSparse, col='blue', lwd=3)
      legend("topleft", c("True f(x)", "Sparse"),
      col = c("red", "blue"), lwd=3)
      options(width=59)
      @
      \end{frame}
      
      \begin{frame}[fragile]
      \frametitle{Comparing Coefficient Estimates}
      
      <<eval=TRUE>>=
      print(betaHat)
      print(betaPost)
      print(betaSparse)
      @
      
      \end{frame}
      
      \end{document}
      