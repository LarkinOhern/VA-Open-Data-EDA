library("httr")

vakey<-"8R4MMFe4kXWcECKlJ3S6Gp0XsGxJxQoI"
appid<-"NAOHern"

va<-GET('https://sandbox-api.va.gov/services/va_facilities/v0/facilities/all' ,
        add_headers(apikey= vakey))
va

http_status(va)

parsed_content(va)
c<-content(va, a='text')

library('utils')
http_type(va)
library("jsonlite")
extract<-fromJSON(c,flatten = TRUE)
extract$type
extract$features
extract$properties
View(extract$features)
workingframe<-extract$features
workingframe$properties.name
workingframe$properties.wait_times.health

library(dplyr)

View(workingframe %>% filter(properties.address.physical.state=="TX"))

FacilitiesByState<-workingframe %>% 
                    filter(properties.active_status=='A') %>%
                      count(properties.facility_type, properties.classification) 
                        
View(FacilitiesByState)

satscores<-workingframe %>% 
  filter(properties.active_status=='A', 
         properties.satisfaction.health.primary_care_routine!="NA",
         properties.satisfaction.health.primary_care_urgent!="NA") %>%
    select(properties.address.physical.state, 
           properties.name, properties.classification,
           properties.satisfaction.health.primary_care_urgent,  
           properties.satisfaction.health.primary_care_routine) %>%
      group_by(properties.classification) %>%
        summarise(AvgRoutineSat=mean(properties.satisfaction.health.primary_care_routine),
                  AvgUrgentSat=mean(properties.satisfaction.health.primary_care_urgent)) 
          
View(satscores)
