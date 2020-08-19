library(data.table)

tw = fread('input/050720_voted_tweets.csv')
tw2 = fread('input/2020-03-11 024837_voted_tweets.csv')
tw = rbindlist(list(tw,tw2),fill = T,use.names = T)
tw$Y = (tw$Category=='Flooding') + 0

nsize = 5000
Y_1 = sample(which(tw$Y==1),replace = sum(tw$Y==1)<nsize,size = nsize)
Y_0 = sample(which(tw$Y==0),replace = sum(tw$Y==0)<nsize,size = nsize)

sample_indices = c(Y_0,Y_1)

write.csv(tw[sample_indices,], 'input/balanced_trainers_V2.csv')
