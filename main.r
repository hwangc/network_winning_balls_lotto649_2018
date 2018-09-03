# Import CSV(1982 ~ 2018)
gameYears <- 2018#1982:2018
totalGames <- as.data.frame(matrix(ncol=6))
totalGames <- totalGames[-c(1),]

for (year in gameYears) {
  ballsInYear <- read.csv(paste("~/Downloads/db649/",year,".csv",sep=""),header=F)
  totalGames <- rbind(totalGames, ballsInYear)
}

numOfDraw <- 1:6
numOfBalls <- 1:49
colnames(totalGames) <- numOfDraw
count <- 1

write("var data = {",file="networkData.js",append = T)

# Nodes
for (ball in numOfBalls) {  
  if(ball == 1) {
    write("[",file="networkData.js",append = T)
  }
  
  json <- toJSON(list(id=paste("n",ball,sep = ""),loaded=TRUE))
  json <- paste(json,"",sep = ",")
  write(json, file="networkData.js",append = T)
  
  if(ball == length(numOfBalls)) {
    write("],",file="networkData.js",append = T)
  }
}

# Links
for (game in 1:nrow(totalGames)) {
  if(game == 1) {
    write("[",file="networkData.js",append = T)
  }
  for (from in 1:ncol(totalGames[game,numOfDraw])) {
    nodeNum <- totalGames[game,numOfDraw][from][,]
    for (to in 1:6) {
      if(from != to) {
        json <- toJSON(list(id=paste("l",count,sep=""), from=paste("n",nodeNum,sep = ""), 
                    to=paste("n",totalGames[game,numOfDraw][to][,],sep = "")))
        json <- paste(json,"",sep = ",")
        
        write(json, file="networkData.js",append = T)
        count = count+1
      }
    }
  }
  print(count)
  if(game == nrow(totalGames)){
    write("]",file="networkData.js",append = T)
      break
  }
}

write("};",file="networkData.js",append = T)
