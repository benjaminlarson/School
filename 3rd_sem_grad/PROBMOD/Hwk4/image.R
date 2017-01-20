require(png)

## Reads a PNG image (as a simple matrix), which for some reason needs to be
## transposed and flipped to be displayed correctly
read.image = function(filename)
{
  y = readPNG(filename)
  
  ## This is just how I encoded pixel intensities
  ## After this, the labels will be black = -1 and white = +1
  y = y * 20 - 10
  
  n = nrow(y)
  
  ## transpose and flip image
  t(y)[,n:1]
}

## Displays an image
display.image = function(x, col=gray(seq(0,1,1/256)))
{
  w = dim(x)[1]
  h = dim(x)[2]
  par(mai = c(0,0,0,0))
  image(x, asp=h/w, col=col)
}
