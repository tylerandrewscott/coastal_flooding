require(data.table)
require(tidyverse)
dt = fread('input/floodingtweets_predictedprobability_comparison.csv')


dt[order(-(Probability_Flooding_V2-Probability_Flooding_V1)),][1:10,][,.(text,Probability_Flooding_V1,Probability_Flooding_V2)]


ggplot(data = dt) + 
  geom_density(aes(x = Probability_Flooding_V1,col = 'Mod1')) + 
  geom_density(aes(x = Probability_Flooding_V2,col = 'Mod2')) + 
  theme_bw() + scale_x_continuous('p(tweet about flooding)') + 
  theme(legend.position = c(0.8,0.4)) + 
  ggtitle('Predicted probabilities')

table(dt$Probability_Flooding_V1>0.8,dt$Probability_Flooding_V2>.8)

dt$Original_Rank = rank( dt$Probability_Flooding_V1,ties.method = 'first')
ggplot(dt) +
  geom_point(aes(y = Probability_Flooding_V2,x = Probability_Flooding_V1))
             
             
  geom_point(aes(x = Original_Rank,y = Probability_Flooding_V2,col = 'V2')) + 
  theme_bw()




  geom_errorbarh(aes(y = V1,xmin=Probability_Flooding_V1,xmax =Probability_Flooding_V2, ))


head(dt)
