P8Win = assert require "lib.P8win"


if P8Win
  Log.info "P8Win instanced."

  maxScale = P8Win.maxScale
  maxWinScale = P8Win.maxWinScale
  
  if maxScale == 6 and maxWinScale == 5
    Log.info "maxScale && maxWinScale are correct."

