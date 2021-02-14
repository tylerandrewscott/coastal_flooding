require(data.table)
fls = list.files('../../../Box/coastal_flooding/output/coastal_city_by_day/',recursive = T,full.names = T)
require(stringr)
require(doParallel)
require(parallel)
require(lubridate)

#cl = makeCluster(4)
#registerDoParallel(cl)
#parallel::clusterEvalQ(cl,require(data.table))
files_by_year = split(fls,str_extract(basename(fls),'^[0-9]{4}'))
files = paste0('../../../Box/coastal_flooding/output/flood_tweets_by_city_hour/flood_tweets_by_city_hour_',names(files_by_year),'.csv')
#files = files[!file.exists(files)]
#files_by_year = files_by_year[str_extract(basename(files),'[0-9]{4}')]

for(f in seq_along(files)){
file = files[f]
fls_temp = files_by_year[[f]]
if(file.exists(file)){
    have = fread(file)
    have[,ymd:= paste(year,formatC(month,width = 2,flag = '0'),day,sep = '-')]
    fls_temp = fls_temp[!ymd(str_remove(basename(fls_temp),'\\.csv')) %in% ymd(have$ymd)]
}
for(i in seq_along(fls_temp)){
    Sys.sleep(0.5)
    print(i)
if(i==1){temp_combo = data.table()}
temp = NULL
while(is.null(temp)){
temp = tryCatch({fread(fls_temp[i])},error = function(e) NULL)
}

temp = temp[Probability_Flooding_V2>0.5,]
temp = temp[,list(sum(Probability_Flooding_V2>0.5),sum(Probability_Flooding_V2>0.75),sum(Probability_Flooding_V2>0.90)),by=.(GEOID,place.name,year,month,day,hour)]
setnames(temp,c('V1','V2','V3'),c('p0.5','p0.75','p0.90'))
#temp = temp[,list(.N),by=.(GEOID,place.name,year,month,day,hour)]
#setnames(temp,c('N'),c('Flooding_Tweets_p.5'))
temp_combo = rbind(temp_combo,temp,use.names = T)
if(i %in% seq(1,length(fls),25)|i == length(fls)){
    if(!file.exists(file)){fwrite(temp_combo,file);temp_combo=data.table()}
        else{fwrite(temp_combo,file,append = T);temp_combo=data.table()}}
    } 
}

