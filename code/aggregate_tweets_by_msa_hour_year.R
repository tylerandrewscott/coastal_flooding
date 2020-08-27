require(data.table)
fls = list.files('output/coastal_city_by_day/',recursive = T,full.names = T)
require(stringr)
aggregate_sets = list()
require(doParallel)
require(parallel)
require(lubridate)
#cl = makeCluster(4)
#registerDoParallel(cl)
yrs = str_extract(basename(fls),'^[0-9]{4}')
uq_yrs = unique(yrs)
#parallel::clusterEvalQ(cl,require(data.table))

fls_year_split = split(fls,yrs)

for(year in seq_along(fls_year_split)){
print(names(fls_year_split )[year])
file = paste0('output/msa_by_hour_year_aggregate/msa_by_hour_',names(fls_year_split)[year],'.csv')
if(file.exists(file)){
temp = fread(file)
temp[,ymd:=paste(year,formatC(month,width = 2,flag = 0),day,sep = '_')];
still_need = fls_year_split[[year]][!ymd(str_remove(basename(fls_year_split[[year]]),'\\.csv')) %in% ymd(temp$ymd)];
}else{still_need = fls_year_split[[year]]}
lst = lapply(seq_along(still_need),function(i){
print(i)
file.exists(still_need[i])
temp = fread(still_need[i])
temp$Flooding <- (temp$Probability_Flooding_V2>0.5) + 0
temp = temp[,list(.N,sum(Flooding)),by=.(GEOID,year,month,day,hour)]
setnames(temp,c('N','V2'),c('Tweets_Collected','Flooding_Tweets_p.5'))
#file.exists(file)
})
temp = rbindlist(lst,use.names = T,fill = T)
temp = temp[!duplicated(temp),]
if(!file.exists(file)){fwrite(x = temp,file = file)}else{fwrite(x = temp,file = file,append = T)}
}

