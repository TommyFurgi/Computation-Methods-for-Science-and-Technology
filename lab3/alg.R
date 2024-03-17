df <- data.frame(size = numeric(0), vector = numeric(0), matrix = numeric(0))

for (x in seq(from=100,to=1000,by=100)){
    for (i in 1:10){
        vector1 <- runif(x,min = 0,max = 9)
        vector2 <- runif(x,min = 0,max = 9)
        matrix1 <- matrix(runif(x*x, min = 0, max = 9), nrow = x, ncol = x)
        start <- Sys.time()
        vector1*vector2
        end <- Sys.time()
        time1 <- end - start
        start <- Sys.time()
        matrix1 * vector1
        end <- Sys.time()
        time2 = end - start   
        df[nrow(df)+1,] <- c(x,time1,time2)
    }
}

write.csv(df, "results.csv")
