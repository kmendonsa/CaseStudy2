# PROCRASTINATION - A GLOBAL ANALYSIS
Kevin Mendonsa & Ruhaab Markas  
November 26, 2017  



### INTRODUCTION

This analysis takes a closer look into the behaviors of procrastination globally, and its correlation if any to the Human Development Index (HDI) and the variables that may contribute to these behaviors. Procrastination is an intentional delay of a course of action despite expecting to be worse. The main purpose of this study is to analyze surveys that measure procrastination. The various surveys used for this analysis are based on the below scales and further information is provided later in this code book.

##### - DECISIONAL PROCRASTINATION SCALE (MANN, 1982)

##### - ADULT INVENTORY OF PROCRASTINATION (MCCOWN & JOHNSON, 1989)

##### - GENERAL PROCRASTINATION SCALE (LAY, 1986)

##### - SATISFACTION WITH LIFE SCALE (DIENER ET AL., 1985)


**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------** 

R - ENVIRONMENT

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------** 


```r
# R-Environment
sessionInfo()
```

```
## R version 3.4.2 Patched (2017-09-30 r73418)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows 7 x64 (build 7601) Service Pack 1
## 
## Matrix products: default
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## loaded via a namespace (and not attached):
##  [1] compiler_3.4.2  backports_1.1.0 magrittr_1.5    rprojroot_1.2  
##  [5] tools_3.4.2     htmltools_0.3.6 yaml_2.1.14     Rcpp_0.12.12   
##  [9] stringi_1.1.5   rmarkdown_1.6   knitr_1.17      stringr_1.2.0  
## [13] digest_0.6.12   evaluate_0.10.1
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

LIBRARIES REQUIRED

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  


```
## Loading required package: gsubfn
```

```
## Loading required package: proto
```

```
## Loading required package: RSQLite
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```
## Loading required package: xml2
```

```
## 
## Attaching package: 'compare'
```

```
## The following object is masked from 'package:base':
## 
##     isTRUE
```

```
## Warning: package 'lucr' was built under R version 3.4.3
```

```
## -------------------------------------------------------------------------
```

```
## You have loaded plyr after dplyr - this is likely to cause problems.
## If you need functions from both plyr and dplyr, please load plyr first, then dplyr:
## library(plyr); library(dplyr)
```

```
## -------------------------------------------------------------------------
```

```
## 
## Attaching package: 'plyr'
```

```
## The following objects are masked from 'package:dplyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
```

```
## Loading tidyverse: ggplot2
## Loading tidyverse: tibble
## Loading tidyverse: readr
## Loading tidyverse: purrr
```

```
## Conflicts with tidy packages ----------------------------------------------
```

```
## arrange():    dplyr, plyr
## col_factor(): readr, scales
## compact():    purrr, plyr
## count():      dplyr, plyr
## discard():    purrr, scales
## failwith():   dplyr, plyr
## filter():     dplyr, stats
## id():         dplyr, plyr
## lag():        dplyr, stats
## mutate():     dplyr, plyr
## rename():     dplyr, plyr
## summarise():  dplyr, plyr
## summarize():  dplyr, plyr
```

```
## 
## Attaching package: 'formattable'
```

```
## The following object is masked from 'package:xtable':
## 
##     digits
```

```
## The following objects are masked from 'package:scales':
## 
##     comma, percent, scientific
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

SET THE WORKING DIRECTORY FOR THE DATA.

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------** 

```r
# Set the working directory for the Data
  BaseDir <- "C:\\Users\\kevinm\\Documents\\GitHub\\CaseStudy2\\source\\"

# set working directory
  setwd(BaseDir)
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

LOAD THE DATA FROM THE CSV FILES AND SCRAPE HDI DATA FROM THE WEB.

https://en.wikipedia.org/wiki/List_of_countries_by_Human_Development_Index

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Load the data from the csv files and scrape HDI data from the web
procrastinate_raw <- read.csv("Procrastination.csv", 
                                  na.strings = "NA", 
                                  blank.lines.skip = TRUE,
                                  sep = ",",
                                  strip.white = TRUE)


# Assign the url to scrape the data from
  HDI_url <- "https://en.wikipedia.org/wiki/List_of_countries_by_Human_Development_Index"

#  HDI_url <- "https://en.wikipedia.org/wiki/List_of_countries_by_Human_Development_Index#Complete_list_of_countries"
  
# Assign the xpaths for the various tables to be scraped from the url
  VHigh_HDI_xpath <- '//*[@id="mw-content-text"]/div/div[5]/table'
   High_HDI_xpath <- '//*[@id="mw-content-text"]/div/div[6]/table'
   Med_HDI_xpath  <- '//*[@id="mw-content-text"]/div/div[7]/table'
   Low_HDI_xpath  <- '//*[@id="mw-content-text"]/div/div[8]/table'

# Scrape the tables from the site and create a data frame for each
  VHigh_HDI_text <- HDI_url %>%
    read_html() %>%
    html_nodes(xpath=VHigh_HDI_xpath) %>% 
    html_table(fill = T) 
  
  High_HDI_text <- HDI_url %>%
    read_html() %>%
    html_nodes(xpath=High_HDI_xpath) %>% 
    html_table(fill = T) 
  
  Med_HDI_text <- HDI_url %>%
    read_html() %>%
    html_nodes(xpath=Med_HDI_xpath) %>% 
    html_table(fill = T) 
  
  Low_HDI_text <- HDI_url %>%
    read_html() %>%
    html_nodes(xpath=Low_HDI_xpath) %>% 
    html_table(fill = T) 

# Create data frames for the scraped data  
  VHigh_HDI_df <- data.frame(VHigh_HDI_text[[1]])
   High_HDI_df <- data.frame( High_HDI_text[[1]])
    Med_HDI_df <- data.frame(  Med_HDI_text[[1]])
    Low_HDI_df <- data.frame(  Low_HDI_text[[1]])

      
# Add the Category for each data frame                               
        VHigh_HDI_df <- sqldf("select 'Very High' as HDICategory,
                               X3 as Country,
                               X4 as HDI
                               from VHigh_HDI_df
                               Where VHigh_HDI_df.X3 not in ('Rank', 'Country',
                               'Change in rank from previous year[1]')")
        
        High_HDI_df <- sqldf("select 'High' as HDICategory,
                              X3 as Country,
                              X4 as HDI
                              from High_HDI_df
                              Where High_HDI_df.X3 not in ('Rank', 'Country',
                              'Change in rank from previous year[1]')")
        
        Med_HDI_df <- sqldf("select 'Medium' as HDICategory,
                              X3 as Country,
                              X4 as HDI
                              from Med_HDI_df
                              Where Med_HDI_df.X3 not in ('Rank', 'Country',
                              'Change in rank from previous year[1]')")
        
        Low_HDI_df <- sqldf("select 'Low' as HDICategory,
                             X3 as Country,
                             X4 as HDI
                             from Low_HDI_df
                             Where Low_HDI_df.X3 not in ('Rank', 'Country',
                             'Change in rank from previous year[1]')")
        
# Merge all the data frames into a single data frame HDI_raw
        HDI_raw <- rbind(VHigh_HDI_df,
                          High_HDI_df,
                           Med_HDI_df,
                           Low_HDI_df )
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  
  
OBSERVATIONS AND VARIABLES FOR EACH DATA FRAME

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**    

```r
 dim(procrastinate_raw)
```

```
## [1] 4264   61
```

```r
 dim(HDI_raw)
```

```
## [1] 189   3
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**THE DATA FRAMES FOR ANALYSIS HAVE THE FOLLOWING OBSERVATIONS AND VARIABLES.**

|DATA FRAME       |OBSERVATIONS | VARIABLES |
|:----------------|:-----------:|:---------:|
|PROCRASTINATION  | **4264**    |**61**     |
|HDI INDEX        | **189**     |**3**      |           


**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------** 

PREPARE DATA FOR CLEANSING AND TRANSFORMATION TO CREATE A CLEAN DATA SET FOR ANALYSIS.

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Add a uniqueID to each row - we may need it later
  procrastinate_raw <- rowid_to_column(procrastinate_raw, "RowID")

# Create a new data frame from raw data for cleansing but retain the original dataset for reference
  procrastinate <- procrastinate_raw
  webscrape     <- HDI_raw
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**   

RENAME THE VARIABLES TO BE EASILY READABLE, CONCISE AND A SHORTER LENGTH. 

REMOVED ALL SPACES TO MAKE THEM MORE INTUITIVE.

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------** 


```r
names(procrastinate) <- c("RowID",
                            "Age",
                            "Gender",
                            "Kids",
                            "Education",
                            "WrkStatus",
                            "Income",
                            "Occupation",
                            "YearsInPos",
                            "MnthsInPos",
                            "CommSize",
                            "Country",
                            "MaritalStat",
                            "Sons",
                            "Daughters",
                            "DP1",
                            "DP2",
                            "DP3",
                            "DP4",
                            "DP5",
                            "AIP1",
                            "AIP2",
                            "AIP3",
                            "AIP4",
                            "AIP5",
                            "AIP6",
                            "AIP7",
                            "AIP8",
                            "AIP9",
                            "AIP10",
                            "AIP11",
                            "AIP12",
                            "AIP13",
                            "AIP14",
                            "AIP15",
                            "GP1",
                            "GP2",
                            "GP3",
                            "GP4",
                            "GP5",
                            "GP6",
                            "GP7",
                            "GP8",
                            "GP9",
                            "GP10",
                            "GP11",
                            "GP12",
                            "GP13",
                            "GP14",
                            "GP15",
                            "GP16",
                            "GP17",
                            "GP18",
                            "GP19",
                            "GP20",
                            "SWLS1",
                            "SWLS2",
                            "SWLS3",
                            "SWLS4",
                            "SWLS5",
                            "SelfProcrast",
                            "OthrProcrast")
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------** 

CONVERT CHARACTER FIELDS TO A CHARACTER DATATYPE FROM FACTORS.

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Convert character fields to a character datatype from factor
  procrastinate$Gender        <- as.character(procrastinate$Gender)
  procrastinate$Kids          <- as.character(procrastinate$Kids)
  procrastinate$Education     <- as.character(procrastinate$Education)
  procrastinate$WrkStatus     <- as.character(procrastinate$WrkStatus)
  procrastinate$Occupation    <- as.character(procrastinate$Occupation)
  procrastinate$CommSize      <- as.character(procrastinate$CommSize)
  procrastinate$Country       <- as.character(procrastinate$Country)
  procrastinate$MaritalStat   <- as.character(procrastinate$MaritalStat)
  procrastinate$SelfProcrast  <- as.character(procrastinate$SelfProcrast)
  procrastinate$OthrProcrast  <- as.character(procrastinate$OthrProcrast)  
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**    
  
**ADD NEW COLUMNS FOR THE MEAN OF EACH SURVEY MEAN BY INDIVIDUAL:**

- DPMean
- AIPMean
- GPMean 
- SWLSMean

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Calculate the means of the 4 individual surveys
  procrastinate <-  transform(procrastinate,  DPMean = rowMeans(procrastinate[,15:19], na.rm = TRUE)) %>% 
                                  transform( AIPMean = rowMeans(procrastinate[,20:34], na.rm = TRUE)) %>%
                                  transform(  GPMean = rowMeans(procrastinate[,35:54], na.rm = TRUE)) %>%
                                  transform(SWLSMean = rowMeans(procrastinate[,55:59], na.rm = TRUE)) 
  
# Round all means to 2 digits  
  procrastinate$DPMean   <- round(procrastinate$DPMean,   digits =2)
  procrastinate$AIPMean  <- round(procrastinate$AIPMean,  digits =2)
  procrastinate$GPMean   <- round(procrastinate$GPMean,   digits =2)
  procrastinate$SWLSMean <- round(procrastinate$SWLSMean, digits =2)
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**    
                       
- REMOVE WHITESPACE BY TRIMMING THE RIGHT AND LEFT SIDES.
- CLEAN UP THE OCCUPATIONS DATA.
- NORMALIZE AND STANDARDIZE FOR CONSISTENCY AND EASE OF DATA ANALYSIS
- OCCUPATIONMAPPING.CSV can be found in the "DATA" folder in the repo

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Trim whitespace on left and right of value  
  procrastinate$Occupation <- str_trim(procrastinate$Occupation) 
  
# Clean up "Occupations"
# Replace all "blank" values with an explicit "*Missing*"
  procrastinate$OccupatnAlt <-gsub("^$","*Missing*",procrastinate$Occupation)
  
# Normalize the data and make it easier to group/categorize if necessary  
  procrastinate$OccupatnAlt <- plyr::revalue(procrastinate$OccupatnAlt ,
c("0" = "*Missing*", 
  "abc"="*Missing*",
  "Academic Assistant"="Academic - Administration",
  "Academic"="Teacher",
  "academic/career coach & admin assistant"="Counselor - career Coach",
  "Account Manager"="Sales - Account Manager",
  "account planner"="Sales - Account Planner",
  "Account Service Rep"="Sales - Account Rep",
  "Accounting Assistant"="Accountant",
  "Accounting Manager"="Accountant",
  "Accounting"="Accountant",
  "Accounts Payable / Fleet Manager"="Accountant",
  "Accounts Payable"="Accountant",
  "acounting analyst"="Accountant",
  "Activities Leader"="*Ambiguous*",
  "adjunct faculty / University + communit"="Professor",
  "admin assist"="Adminstrative Assistant",
  "Administration Assistant"="Adminstrative Assistant",
  "Administrative Asistant for Jewelry Stor"="Admin Assistant",
  "Administrative Officer"="Administrator",
  "advocate"="Attorney",
  "airline"="*Missing*",
  "airport ground handler"="airport ground handler",
  "Artist/ designer/builder"="Artist",
  "Artist/administrator"="Artist",
  "artist/designer/homemaker"="Artist",
  "Assistant District Attorney"="Attorney",
  "assistant general counsel"="Attorney",
  "assistant professor"="Professor",
  "Assistant"="Administrative Assistant",
  "Assoc. Governmental Program Analyst"="Program Analyst",
  "Associate / investment banking"="Banking - Investment associate",
  "associate at law firm"="Attorney",
  "Associate Director"="Film/TV - Associate Director",
  "Associate director/ marketing communicat"="Marketing - Communications",
  "Associate Producer"="Film/TV - Associate Producer",
  "asst"="Assistant",
  "Asst. Pre-school Teacher"="Teacher",
  "Asst. Prof."="Professor",
  "Attorney-self employed"="Attorney",
  "audio engineer"="Engineer - Audio",
  "Bank Teller"="Banking - teller",
  "banker"="Banking",
  "Bar & Restaurant Owner"="Restaurant & Bar Owner",
  "bookkeeper/ actor"="Bookkeeper",
  "Business / Test Analyst"="IT - Systems Analyst",
  "BUSINESS CONSULTA"="Business consultant",
  "business manager"="Manager",
  "Business Owner"="Business Owner / Self Employed",
  "Business Systems Analyst"="IT - Systems Analyst",
  "business"="Business Owner / Self Employed",
  "businesswoman"="Business Owner / Self Employed",
  "C E O/ M D"="CEO",
  "Campus Planner"="Planner - Campus",
  "Capstone Golf Course"="*Ambiguous*",
  "Career Placement Associate"="Counselor - career Placement",
  "Casting Director"="Film - casting Director",
  "catholic priest/ full timestudent"="Priest",
  "Certified Nurse's Assistant"="Nursing - Certified Assistant",
  "chairman of the board"="Chairman",
  "chauffeur"="Driver",
  "Chief Financial Officer"="CFO",
  "Chiefe Development Engineer"="Engineer - Development",
  "Client Relationship Assistant"="Sales - Client Relationship Assistant",
  "Clinical Dietitian"="Dietitian - Clinical",
  "Collection management specialist"="Collections",
  "College Administrator"="Academic - Administration",
  "college faculty"="Professor",
  "college professor"="Professor",
  "Communications & Publishing"="Communications & Publishing",
  "company director"="Director",
  "Computer Consultant"="IT - Consultant",
  "Computer Instructor (Continuing Educatio"="Teacher",
  "Computer Operator"="IT - Systems Analyst",
  "Computer Programmer"="IT - Software Engineer",
  "Computer Science"="IT - Systems Analyst",
  "Computer Systems Analyst"="IT - Systems Analyst",
  "Computers"="IT Systems Analyst",
  "Consultant and entrepreneur (small busin"="Business Owner / Self Employed",
  "Consumer Case Coordinator"="Case Coordinator - Consumer",
  "Controller"="Financial Controller",
  "Contsuruction Management"="Construction Management",
  "Coordinator of International Programs"="Program Coordinator",
  "coordinatore operativo"="Operations - Coordinator",
  "Co-Proprietor"="Business Owner / Self Employed",
  "Corporate instructor"="Corporate Trainer",
  "Corporation President"="President",
  "Corrections"="Corrections Officer",
  "Country Style Employee"="*Ambiguous*",
  "CRNA"="Nursing - Certified Registered Anesthetist",
  "Customer Service at Domino's Pizza"="Customer Service",
  "Data Warehouse Engineer"="IT - DW Engineer",
  "Dealer"="*Ambiguous*",
  "Dental & Disability Coordinator"="Dental & Disability Coordinator",
  "Dept. Director (Non-profit)"="Non Profit - Director",
  "Deputy Chief of Public Information for t"="Public Information - Deputy Chief",
  "Deputy Chieif Information Officer"="IT - CIO (Deputy)",
  "deputy practice manager"="*Ambiguous*",
  "detail checker"="*Ambiguous*",
  "Developer"="IT Software engineer",
  "Diplomat"="Foreign Affairs",
  "Director / information technology"="IT - Director",
  "Director of a language program"="Language - Program Director",
  "Director of Academic Affairs"="Academic - Administration (Director)",
  "Director of business development"="Business Development - Director",
  "Director of Contract Management"="Contract Management - Director",
  "Director of non-profit organization"="Non Profit - Director",
  "Director of Software Company"="Director",
  "Director Operations"="Operations - Director",
  "Disability Allowance"="*Ambiguous*",
  "Dish Washer"="Dishwasher",
  "Divisional Manager of a large cosmetics"="Director",
  "Doctor Research"="Physician - Research",
  "Doctor; Physician"="Physician",
  "Early child hood teacher"="Teacher",
  "Early Childhood Education Student/ Nanny"="Student",
  "Economy"="Economist",
  "Editor Attorney"="Attorney",
  "Education (at a university)"="Professor",
  "education administration"="Academic - Administration",
  "Education Specialist"="Academic - Administration",
  "education"="Teacher",
  "Educator/Student"="Teacher",
  "EFL Teacher/ Professional Researcher"="Teacher",
  "EHS Manager"="Environmental - EHS Manager",
  "Electrical Technician"="Electrician",
  "employed by a church"="*Ambiguous*",
  "energy therapist"="Therapist - Energy",
  "Entrepreneur & Consultant"="Business Owner / Self Employed",
  "entrepreneur"="Business Owner / Self Employed",
  "environmental education non profit direc"="Environmental - Education/Non Profit",
  "Environmental Senior Specialist"="Environmental Specialist",
  "EOD"="Military - Explosive Ordinance Disposal",
  "Epidemiologist"="Physician - Epidemiologist",
  "ESL Teacher/Biologist"="Teacher",
  "Executive Vice President / Senior Lender"="Vice President",
  "fdsdf"="*Missing*",
  "federal excise tax auditor"="Tax Auditor",
  "film editor"="Film - Editor",
  "Film Industry/Miscelanious"="Film - Other",
  "Film maker"="Film - Maker",
  "financial officer / small career-trainin"="financial officer",
  "First VP & Associate General Counsel"="Attorney",
  "Fitness Assistant / wellness mentor / ca"="Fitness Instructor - Wellness mentor",
  "Framer/Sales Associate"="Framer",
  "free lance bookkeeper"="Bookkeeper",
  "Free lance editor and tutor--in theory"="Editor - Freelance",
  "free professionist"="Business Owner / Self Employed",
  "Freelance ESL Teacher"="Teacher",
  "Freelance musician / part time EMT / pri"="Musician",
  "Freelance Project Manager"="Project Manager",
  "Freelance"="Business Owner / Self Employed",
  "full time student and part time bartende"="Student",
  "Full-Time Mother / Part-Time Editor"="home maker",
  "fulltime office assistant"="Office Assistant",
  "Gender/Public Health Consultant"="Public Health - Consultant",
  "Gove service"="Civil servant",
  "Graduate Research Assistant"="Graduate Assistant - Research",
  "Graduate Researcher"="Researcher - Graduate",
  "Graduate student/University instructor"="Student",
  "Graduate student--research and teaching"="Student",
  "Grease Monkey"="*Ambiguous*",
  "Grocery Store Salesman"="Grocery Store Salesman",
  "Head - Operations & QA"="Operations & QA",
  "health care"="Healthcare",
  "Healthcare Consultant"="Healthcare - Consultant",
  "host"="Restaurant - Host/Hostess",
  "hostess"="Restaurant - Host/Hostess",
  "Hotel Desk Clerk"="Hospitality - Desk Clerk",
  "Housekeeping"="Hospitality - Housekeeping",
  "houswife"="home maker",
  "Human Resource Manager"="HR Manager",
  "Human Resource Manger"="HR Manager",
  "information assisstant"="IT - Assistant",
  "Information Developer"="IT - Software engineer",
  "Information Management"="IT - Manager",
  "Information Technology Consultant"="IT - Consultant",
  "Information technology"="IT",
  "In-house Legal Counsel"="Attorney",
  "innkeeper"="Hospitality - innkeeper",
  "Instructional Assistant Online"="Instructor - Online Assistant",
  "instructor / coach"="Instructor - Coach",
  "intern"="*Ambiguous*",
  "Internet & media consultant"="Media & Internet - Consultant",
  "Internship"="*Ambiguous*",
  "interpreter"="Translator / Interpreter",
  "Investment Assistant"="Banking - Investment Assistant",
  "investment banker"="Banking - Investment banker",
  "Investment Counsel"="Banking - Investment Counselor",
  "ISTraining Coordinator"="IT - Training Coordinator",
  "IT admin"="IT Administrator",
  "IT Support"="IT - Support Engineer",
  "IT systems administrator"="IT - Systems Analyst",
  "IT Technician"="IT - Support Engineer",
  "jewelry artist"="Artist - jewelry",
  "journalist (freelance)"="Journalist",
  "Juvenile Corrections Officer"="Corrections Officer - Juvenile",
  "Lab Director/Archeologist"="Lab Director",
  "Lab Services Assistant"="Lab  Assistant",
  "laboratory technician"="Lab Technician",
  "laborer (construction)"="Construction",
  "land use planner"="Planner - land use",
  "Law clerk"="Legal Clerk",
  "lecturer"="Professor",
  "Legal Assistant / Office Manager"="Legal Assistant / Office Manager",
  "Library Assistant"="Librarian Assistant",
  "library paraprofessional"="Librarian",
  "Library technician"="Librarian",
  "Lift Ops"="Lift Operator",
  "LPN"="Nursing - Licensed Practical",
  "maintenance tech."="Maintenance technican",
  "Management Consultant & Entrepreneur"="Management consultant",
  "Manager - Analytical and Environmental S"="Environmental - Analytical Manager",
  "manager IT"="IT - Manager",
  "Market Analyst"="Marketing Research Analyst",
  "Market Research Analyst"="Marketing Research Analyst",
  "Marketing"="Marketing",
  "md"="*Ambiguous*",
  "Mechanical Engineer"="Engineer - mechanical",
  "mktg"="Marketing",
  "musician/student/teacher"="Musician",
  "na"="*Missing*",
  "Nanny and student"="Nanny",
  "Network Engineer"="IT Network Engineer",
  "Network Services Engineer"="IT Network Engineer",
  "new realtor"="Realtor",
  "newspaper carrier"="Newspaper delivery",
  "Non-profit Consultant"="Non-profit Consultant",
  "Office Manager / Accountant"="Office Manager",
  "Office Services Manager"="Office Manager",
  "office"="Office Admin",
  "Online Media Buyer"="Buyer - Online Media",
  "Organic Grocery Store Cashier/shift lead"="Cashier",
  "Ornithology Graduate Student and Teachin"="Student",
  "ouh"="*Missing*",
  "owner - private practice physical therap"="Physical Therapist",
  "Owner"="Business Owner / Self Employed",
  "Page Designer for a newspaper"="Graphic Designer",
  "Paraprofessional"="*Ambiguous*",
  "Parent Educator/Supervisor"="home maker",
  "Partner"="*Ambiguous*",
  "PCA for a quadrapilegic and a PCA for a"="PCA - Quadriplegic",
  "Pharmaceutical Merchandiser"="Merchandiser - Pharmaceutical",
  "pharmacy tech."="Pharmacist",
  "phd student researcher"="Student",
  "photo profucer"="Photographer",
  "physician (internist)"="Physician - Intern",
  "Physiotherapst"="Physiotherapst",
  "pjublic relations director"="Public Relations",
  "Please specify title Manager for Regulat"="*Missing*",
  "please specify" = "*Missing*",
  "Post Grad Physician"="Physician - Post Grad",
  "Postdoc"="Student - Post Doctoral",
  "Postdoctoral Researcher"="Researcher - Post Doctoral",
  "pr and communications firm owner"="Public Relations",
  "President Nongovernmental organization"="President - NGO",
  "president/CEO"="CEO",
  "Probation Supervisor"="Probation officer",
  "Process Engineer"="Engineer - Process",
  "Procrastinator"="*Missing*",
  "Produce Associate"="Grocery Store - produce associate",
  "producer"="Film - Producer",
  "Production Operations Support Analyst"="Operations - Production Support Analyst",
  "Professional Organizer"="Organizer - professional",
  "Professional Soccer Player"="Soccer Player - Professional",
  "Programmer Analyst"="IT Software engineer",
  "Programmer"="IT Software engineer",
  "Programmer/Developer"="IT Software engineer",
  "Programmer/Software Analyst"="IT Software engineer",
  "Proposal Director"="Contract/Proposal - Director",
  "psychologis"="Psychologist",
  "P-T College Faculty & P-T Self-Employed"="Professor",
  "real estate broker"="Realtor",
  "Real estate developer"="Real Estate Developer",
  "real estate"="Real estate agent",
  "realtor"="real estate agent",
  "Reasearch assistant"="Research Assistant",
  "Receptionist"="Receptionist",
  "Recreational Staff"="Recreational Staff",
  "Regional Sales Manager"="Sales - Manager",
  "Registered Respiratory Therapist"="Respiratory - Therapist",
  "Residence Don"="Residential Services - Supervisor",
  "resident physician"="Physician",
  "restaurant mgr / student / and looking f"="Restaurant Operations - Mgr",
  "Retail / artist /writer"="Retail",
  "retired/adjunct"="Retired",
  "RN - Medical Sales"="Sales - medical",
  "RN"="Nurse - RN",
  "rocket scientist"="Scientist - Rocket",
  "s"="*Missing*",
  "School Counselor"="Counselor - School",
  "school"="Student",
  "Science writing intern"="Writer - Science (intern)",
  "secretary"="Admin Assistant",
  "Self employed Public Relations"="Public Relations",
  "Self Employed"="Business Owner / Self Employed",
  "self employeed"="Business Owner / Self Employed",
  "Self-Employed / personal trainer / stren"="Personal Trainer",
  "Self-employed Family Therapist"="Therapist - Family",
  "self-employed freelance writer/author"="Writer/Author - Freelance",
  "self-employed Photographer"="Photographer",
  "self-employed translator"="Translator",
  "Self-employed writer/editor"="Writer/Author - Freelance",
  "selfemplyed renovator"="Renovator",
  "Senior Consultant Programmer/Analyst"="IT Programmer - Consultant",
  "senior consultant"="Consultant Sr.",
  "Senior Human Resources Consultant"="HR Consultant",
  "Senior Policy Advisor"="Policy Advisor",
  "senior project manager"="Project Manager",
  "Senior Records Analyst"="Records Analyst",
  "Senior Staff Writer"="Writer",
  "Senior Systems Analyst"="IT Systems Analyst",
  "Server"="Restaurant - Food Server",
  "Service Registrar/English Instructor"="Teacher",
  "Shipping/receiving/warehouse mgnt"="Warehousing",
  "Software analyst"="IT Software engineer",
  "Software Developer"="IT Software engineer",
  "Software engineer"="IT Software engineer",
  "Software Pro"="IT Software professional",
  "Software Sales"="Sales - Software",
  "Software trainer"="Training -  Software",
  "Special Projects Editor"="Editor - Special Projects",
  "specialist"="*Ambiguous*",
  "Speech and language Assistant"="language and Speech Assistant",
  "Sr. Drug Safety Associate"="Drug Safety",
  "Stay-at-home dad"="home-maker",
  "Studey"="Student",
  "supervising program development speciali"="Program Development Specialist",
  "supervisor shelderd workshop for handcap"="Social Worker - Handicap",
  "Supervisor"="*Ambiguous*",
  "Surgical Resident"="Surgeon - resident",
  "System Analyst"="IT Systems Analyst",
  "system manager"="IT Systems Analyst",
  "Systems Analyst"="IT Systems Analyst",
  "Systems Programmer/Analyst"="IT Systems Analyst",
  "Tech Support"="Technical Support",
  "Technology (CTO)"="IT - CTO",
  "Technology Curriculum Developer Science"="Technology Curriculum Developer Science",
  "Temp"="*Ambiguous*",
  "temporary office"="*Ambiguous*",
  "Test Item Writer (Self-employed)"="Writer - Testing",
  "Tour Guide"="Tour Guide",
  "Town Planner"="Planner - Town",
  "Traffic Reporter-Radio"="Reporter - Traffic",
  "trainee"="*Ambiguous*",
  "university faculty"="Professor",
  "University Staff"="Academic - Administration",
  "Urban Planner/Economic Development Plann"="Planner - Urban",
  "'Utterly shiftless arts student'... at p"="Student",
  "Vetrans Representative"="Veterans Representative",
  "vidoe"="Videographer",
  "VMD"="*Ambiguous*",
  "VP Scientific Affairs / pharmaceutical c"="Scientific Affairs - VP"
   ))
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**    

RENAME VALUES IN THE FIELD "EDU" TO MEANINGFUL NAMES AND LOAD TO A NEW COLUMN NAMED "EDUCATIONALT"

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Format and expand on the Education abbreviations to meaningful values
ELSE <- TRUE
procrastinate <- procrastinate %>%
                            mutate(EducationAlt = case_when(
                                                            .$Education == "ma"      ~ "Masters",
                                                            .$Education == "deg"     ~ "Degree",
                                                            .$Education == "dip"     ~ "Diploma",
                                                            .$Education == "grade"   ~ "Elementary School",
                                                            .$Education == "high"    ~ "High School",
                                                            .$Education == "lthigh"  ~ "Left High School",
                                                            .$Education == "ltuni"   ~ "Left University",
                                                            .$Education == "phd"     ~ "PhD",
                                                            ELSE                     ~ "*Missing*"
                                                           )
                                    ) 
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

CLEAN OTHER FIELDS AS APPROPRIATE.

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Replace missing values in "Gender" with an explicit "*Missing*"
procrastinate$Gender <- gsub("^$", "*Missing*", procrastinate$Gender)

# Remove the word "Kids", replace blanks with "*Missing*"" and capitalize first letter
procrastinate$Kids <- gsub(" Kids","", 
                            gsub("^$","*Missing*",procrastinate$Kids ))


# Replace 0 & blanks with "*Missing*" and capitalize first letter
procrastinate$WrkStatus <- gsub("^0$","*Missing*", 
                                gsub("^$","*Missing*", procrastinate$WrkStatus)) 
                                 

# Replace 999 & blanks with "*Missing*" and convert to integer and round
procrastinate$YearsInPos <- gsub("^999$",NA, # Replace 999 to "*Missing*"
                            gsub("^$" ,NA, 
                           round(as.integer(procrastinate$YearsInPos), digits = 0 )))

# Replace 0 and blanks to "*Missing*"
procrastinate$MaritalStat <- gsub("0","*Missing*", 
                                 gsub("^$" , "*Missing*", procrastinate$MaritalStat))

# Replace blanks, 0 & 8 with "*Missing*" 
procrastinate$CommSize <- gsub("^$" , "*Missing*", procrastinate$CommSize)

procrastinate$CommSize <- plyr::revalue(procrastinate$CommSize,
                                        c("0" = "*Missing*", 
                                          "8" = "*Missing*"))

# Replace 0 with "*Missing*"
procrastinate$Country <- gsub("0","*Missing*", 
                                  gsub("^$" , "*Missing*", procrastinate$Country))

# Set Male=1 and Female=2 in field = "Sons"
procrastinate$Sons <- gsub("Female", "^2$", 
                      gsub("Male", "^1$", procrastinate$Sons))

# Convert fields to integer as required
procrastinate$Sons <- as.integer(procrastinate$Sons)
```

```
## Warning: NAs introduced by coercion
```

```r
# Clean up "Self Procrastinator" field by setting blanks to an explicit "*Missing*" 
procrastinate$SelfProcrast <- gsub("^$" , "*Missing*", procrastinate$SelfProcrast)

# Clean up the field "Others say you are a procrastinator" by replacing 0s, 4s & "blanks" with "*Missing*" 
procrastinate$OthrProcrast <- gsub("^$" , "*Missing*", procrastinate$OthrProcrast)

procrastinate$OthrProcrast <- plyr::revalue(procrastinate$OthrProcrast,
                                        c("^0$" = "*Missing*", 
                                          "^4$" = "*Missing*"))
```

```
## The following `from` values were not present in `x`: ^0$, ^4$
```

```r
# format Income to dollar currency
# HDIMerged$IncomeCurr <- to_currency( HDIMerged$Income, currency_symbol = "$", symbol_first = TRUE,
#                                     group_size = 3, group_delim = ",", decimal_size = 0,
#                                     decimal_delim = ".") 

# Change to "Title" case
procrastinate$Kids           <- str_to_title(procrastinate$Kids, locale = "en") # Replace blanks with "*Missing*"
procrastinate$SelfProcrast   <- str_to_title(procrastinate$SelfProcrast, locale = "en") # Change to "Title" case
procrastinate$OthrProcrast   <- str_to_title(procrastinate$OthrProcrast, locale = "en") # Change to "Title" case
procrastinate$OccupatnAlt    <- str_to_upper(procrastinate$OccupatnAlt, locale = "en") # Change to UPPER case
procrastinate$WrkStatus      <- str_to_title(procrastinate$WrkStatus, locale = "en")
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

MERGE THE WEBSCRAPE AND PROCRASTINATE DATA FRAMES ON COUNTRY DOING A LEFT JOIN ON WEBSCRAPE.

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Let's trim all whitespace in the country field of the webscrape
HDI_raw$Country <- str_trim(HDI_raw$Country) # Trim whitespace on left and right of value
procrastinate$Country <- str_trim(procrastinate$Country) # Trim whitespace on left and right of value

# Rectify some name spellings in the countries between the web data and the procrastinate data
procrastinate$Country <- plyr::revalue(procrastinate$Country,
                                            c("Columbia" = "Colombia", 
                                              "Isreal"   = "Israel"))

# Merge the two data sets to a single data set
HDIMerged <- merge(procrastinate, HDI_raw, by = "Country", all.x = TRUE)

# Replace NA with explicit *Missing* in HDI category
HDIMerged$HDICategory[is.na(HDIMerged$HDICategory)] <- "*Missing*"
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**PRELIMINARY DATA ANALYSIS**

*For the purpose of this analysis we have eliminated all participants under 18 years of age.  This will permit a focus on primarily employment eligible individuals.  Furthermore, we have also excluded all participants 80 years and above for a similar purpose.The intention is not to skew our analysis in any way with bias from participants 18 and below and 80 and above.*

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**DESCRIPTIVE STATISTICS OF KEY FACTORS**

- AGE
- INCOME 
- HDI

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# create data frames for each of the 3 variables
AGE    <- HDIMerged$Age
INCOME <- HDIMerged$Income
HDI    <- HDIMerged$HDI

# Combine them inot a single data frame
d <- data.frame(AGE,INCOME, HDI )

# Generate the descriptive statistics
summary(d)
```

```
##       AGE            INCOME            HDI      
##  Min.   : 7.50   Min.   :     0   0.920  :3143  
##  1st Qu.:28.00   1st Qu.: 15000   0.909  : 184  
##  Median :32.50   Median : 45000   0.939  : 117  
##  Mean   :37.43   Mean   : 58916   0.624  :  78  
##  3rd Qu.:45.00   3rd Qu.: 67500   0.887  :  67  
##  Max.   :80.00   Max.   :250000   (Other): 428  
##  NA's   :71      NA's   :548      NA's   : 247
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**SURVEY MEANS**

- DP
- GP
- AIP
- SWLS

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
DP   <- HDIMerged$DPMean
GP   <- HDIMerged$GPMean
AIP  <- HDIMerged$AIPMean
SWLS <- HDIMerged$SWLSMean

d <- data.frame(DP,GP, AIP, SWLS )

summary(d)
```

```
##        DP              GP             AIP             SWLS      
##  Min.   :0.800   Min.   :1.000   Min.   :1.000   Min.   :1.000  
##  1st Qu.:2.000   1st Qu.:2.750   1st Qu.:2.330   1st Qu.:2.600  
##  Median :2.600   Median :3.250   Median :2.930   Median :3.200  
##  Mean   :2.598   Mean   :3.227   Mean   :2.936   Mean   :3.205  
##  3rd Qu.:3.200   3rd Qu.:3.750   3rd Qu.:3.530   3rd Qu.:3.800  
##  Max.   :6.000   Max.   :5.000   Max.   :5.000   Max.   :5.000
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**HISTOGRAM: AIP MEAN**

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Exclude all observations where the participant is under 18 years of age and 80 and over
# Removed the age group 80 and above - Provide reason
HDIMerged <- filter(HDIMerged, Age > 18) %>%
                filter(Age < 79 )

# Histogram for AIPMean
ggplot(data=HDIMerged, aes(x=HDIMerged$AIPMean)) + 
  geom_histogram(binwidth = .25, 
                 col="black", 
                 fill="blue", 
                 alpha = .2) + 
  labs(title="Histogram of AIP Mean", x="AIP Mean", y="Count") + 
  xlim(c(0,5)) + 
  ylim(c(0,550)) +
  theme(plot.title = element_text(hjust = 0.5, vjust=0.5))
```

<img src="CaseStudy22_files/figure-html/histograms_AIP-1.png" style="display: block; margin: auto;" />
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**THE DISTRIBUTION OF THE AIP MEAN OF THE SURVEYED PARTICIPANTS**

- The distribution has some appearance of a bi-modal distribution but it fits a normal distribution well.

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**HISTOGRAM: GP MEAN**

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Histogram for GPMean
ggplot(data=HDIMerged, aes(x=HDIMerged$GPMean)) + 
  geom_histogram(binwidth = .25, 
                 col="red", 
                 fill="green", 
                 alpha = .2) + 
  labs(title="Histogram of GP MEAN", x="GP Mean", y="Count") + 
  xlim(c(0,5)) + 
  ylim(c(0,550)) +
  theme(plot.title = element_text(hjust = 0.5, vjust=0.5))
```

<img src="CaseStudy22_files/figure-html/histograms_GP-1.png" style="display: block; margin: auto;" />
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**THE DISTRIBUTION OF THE GP MEAN OF THE SURVEYED PARTICIPANTS**

- The distribution for the for the GP mean has some left skew but still conforms to a normal distribution.
 
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# Gender Frequency
GenderFreq <- sqldf("select Gender as 'GENDER', count(1) as 'COUNT'
                      from HDIMerged
                      Group by Gender
                      Order by 2 desc")

# Table to display gender frequency
kable(GenderFreq, "html") %>%
kable_styling("striped", full_width = F, position = "left" ) %>%
column_spec(2, bold = T) %>%
row_spec(3, bold = T, color = "white", background = "#D7261E")
```

<table class="table table-striped" style="width: auto !important; ">
<thead><tr>
<th style="text-align:left;"> GENDER </th>
   <th style="text-align:right;"> COUNT </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Female </td>
   <td style="text-align:right;font-weight: bold;"> 2295 </td>
  </tr>
<tr>
<td style="text-align:left;"> Male </td>
   <td style="text-align:right;font-weight: bold;"> 1708 </td>
  </tr>
<tr>
<td style="text-align:left;font-weight: bold;color: white;background-color: #D7261E;"> *Missing* </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #D7261E;"> 6 </td>
  </tr>
</tbody>
</table>
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**DEMOGRAPHICS OF POLLED RESPONDENTS: MEAN AGE ~ 37 yrs.**

|DATA FRAME       |COUNT        | PERCENT |
|:----------------|:-----------:|:-------:|
|FEMALE           | **2295**    |**57%**  |
|MALE             | **1708**    |**43%**  |  

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

```r
# WorkStatus frequency
WrkStatusFreq <- sqldf("select WrkStatus as 'WORK STATUS', count(1) as 'COUNT'
                        from HDIMerged
                        Group by WrkStatus
                        Order by 2 desc")

# Table to display work status frequency
kable(WrkStatusFreq, "html") %>%
kable_styling("striped", full_width = F, position = "left" ) %>%
column_spec(2, bold = T) %>%
row_spec(6, bold = T, color = "white", background = "#D7261E")
```

<table class="table table-striped" style="width: auto !important; ">
<thead><tr>
<th style="text-align:left;"> WORK STATUS </th>
   <th style="text-align:right;"> COUNT </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Full-Time </td>
   <td style="text-align:right;font-weight: bold;"> 2259 </td>
  </tr>
<tr>
<td style="text-align:left;"> Student </td>
   <td style="text-align:right;font-weight: bold;"> 837 </td>
  </tr>
<tr>
<td style="text-align:left;"> Part-Time </td>
   <td style="text-align:right;font-weight: bold;"> 463 </td>
  </tr>
<tr>
<td style="text-align:left;"> Unemployed </td>
   <td style="text-align:right;font-weight: bold;"> 257 </td>
  </tr>
<tr>
<td style="text-align:left;"> Retired </td>
   <td style="text-align:right;font-weight: bold;"> 151 </td>
  </tr>
<tr>
<td style="text-align:left;font-weight: bold;color: white;background-color: #D7261E;"> *Missing* </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #D7261E;"> 42 </td>
  </tr>
</tbody>
</table>
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

**THE FREQUENCY DISTRIBUTION OF THE WORK STATUS OF THE PARTICIPANTS IS:**

|WORK TYPE  |COUNT     | PERCENT  |
|:----------|:--------:|:--------:|
|FULL-TIME  |**2259**  |**56**    |
|STUDENT    |**837**   |**21%**   |  
|PART-TIME  |**463**   |**12%**   |
|UNEMPLOYED |**257**   |**6%**    |
|RETIRED    |**151**   |**4%**    |  
|*MISSING*  |**42**    |**1%**    |


**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

```r
# data set of participants grouped by country
Country <- sqldf ("select Country, Count(1) as Participants
                    from HDIMerged
                    Where Country<>'*Missing*'
                    Group by Country
                    Order by 2 desc")

# formatting the dataset to arrange the data in 6 columns
Country1 <- Country[1:30,]
Country2 <- Country[31:60,]
Country3 <- Country[61:90,]
CountryCount <- cbind(Country1, Country2,Country3)
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

- *US is 72% of the sample population surveyed. The Top 8 countries account for ~ 90% of survey respondents.*

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

```r
# A table of the participants by country
kable(CountryCount, "html") %>%
kable_styling("striped", full_width = F, position = "center" ) %>%
column_spec(c(2,4,6), bold = T, background = "lightblue") 
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;"> Country </th>
   <th style="text-align:right;"> Participants </th>
   <th style="text-align:left;"> Country </th>
   <th style="text-align:right;"> Participants </th>
   <th style="text-align:left;"> Country </th>
   <th style="text-align:right;"> Participants </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> United States </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2767 </td>
   <td style="text-align:left;"> Poland </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 5 </td>
   <td style="text-align:left;"> Bahamas </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Canada </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 243 </td>
   <td style="text-align:left;"> Romania </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 5 </td>
   <td style="text-align:left;"> Barbados </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> United Kingdom </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 177 </td>
   <td style="text-align:left;"> Chile </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 4 </td>
   <td style="text-align:left;"> Bolivia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Australia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 99 </td>
   <td style="text-align:left;"> Croatia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 4 </td>
   <td style="text-align:left;"> Botswana </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> India </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 78 </td>
   <td style="text-align:left;"> Malaysia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 4 </td>
   <td style="text-align:left;"> Cyprus </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Italy </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 60 </td>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 4 </td>
   <td style="text-align:left;"> Dominican Republic </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Germany </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 36 </td>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 3 </td>
   <td style="text-align:left;"> Egypt </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 20 </td>
   <td style="text-align:left;"> Algeria </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 3 </td>
   <td style="text-align:left;"> El Salvador </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Ireland </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 19 </td>
   <td style="text-align:left;"> Argentina </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 3 </td>
   <td style="text-align:left;"> Guam </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Israel </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 19 </td>
   <td style="text-align:left;"> Austria </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 3 </td>
   <td style="text-align:left;"> Guyana </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Netherlands </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 18 </td>
   <td style="text-align:left;"> Czech Republic </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 3 </td>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Sweden </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 15 </td>
   <td style="text-align:left;"> Ecuador </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 3 </td>
   <td style="text-align:left;"> Iceland </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Norway </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 14 </td>
   <td style="text-align:left;"> Puerto Rico </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 3 </td>
   <td style="text-align:left;"> Jamaica </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> France </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 13 </td>
   <td style="text-align:left;"> Uruguay </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 3 </td>
   <td style="text-align:left;"> Kenya </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Japan </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 13 </td>
   <td style="text-align:left;"> Albania </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Lithuania </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Spain </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 13 </td>
   <td style="text-align:left;"> Bermuda </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Luxembourg </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> China </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 12 </td>
   <td style="text-align:left;"> Bulgaria </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Macao </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Finland </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 12 </td>
   <td style="text-align:left;"> Colombia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Macedonia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> New Zealand </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 12 </td>
   <td style="text-align:left;"> Ghana </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Morocco </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> South Africa </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 12 </td>
   <td style="text-align:left;"> Iran </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Myanmar </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mexico </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 11 </td>
   <td style="text-align:left;"> Malta </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Philippines </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 11 </td>
   <td style="text-align:left;"> Peru </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Pakistan </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Switzerland </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 11 </td>
   <td style="text-align:left;"> Saudi Arabia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Panama </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Greece </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 10 </td>
   <td style="text-align:left;"> South Korea </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Qatar </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Belgium </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 9 </td>
   <td style="text-align:left;"> Thailand </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Russia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Denmark </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 9 </td>
   <td style="text-align:left;"> Ukraine </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Turkey </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 9 </td>
   <td style="text-align:left;"> Venezuela </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Taiwan </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hong Kong </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 7 </td>
   <td style="text-align:left;"> Yugoslavia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 2 </td>
   <td style="text-align:left;"> Vietnam </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Portugal </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 7 </td>
   <td style="text-align:left;"> Andorra </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> NA </td>
  </tr>
<tr>
<td style="text-align:left;"> Slovenia </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 6 </td>
   <td style="text-align:left;"> Antigua </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> 1 </td>
   <td style="text-align:left;"> NA </td>
   <td style="text-align:right;font-weight: bold;background-color: lightblue;"> NA </td>
  </tr>
</tbody>
</table>

```r
# Matches of how many people had others that agreed with their perceptions
Matched <- sqldf ("select Count(1) as 'MATCHES'
                    from HDIMerged
                    Where SelfProcrast=OthrProcrast
                    ")

Matched
```

```
##   MATCHES
## 1    2826
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

- THERE ARE **2826** PERSONS THAT MATCHED THEIR PERCEPTIONS TO OTHERS.  
- THESE ARE PEOPLE THAT SAID THEY FELT THEY WERE OR WERE NOT PROCRASTINATORS AND OTHERS AGREED WITH THEIR ASSESSMENT.

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

```r
#### Question 5 - Deeper Analysis ##################################

# Create a bargraph of top 15 countries colored by HDI Category

# Aggregate the average DP Mean by country
DPMeanByCountry <- select(HDIMerged, Country, DPMean) %>%
                  filter(Country!="*Missing*") %>%
                  aggregate(DPMean ~ Country, .,mean)

# Distinct list of Country and HDI category
HDICategoryByCountry <- distinct(select(HDIMerged, Country, HDICategory))

# Merge the aggregate of DPMean and the distinct country and HDI category
Top15ProcrastinatorsDP <- merge(DPMeanByCountry, HDICategoryByCountry, by = "Country", all.x = TRUE) %>%
                            arrange(desc(DPMean)) %>%
                            slice(1:15)

# Top 15 nations with their HDI scores for DP
Top15DPWithHDI <- merge(Top15ProcrastinatorsDP, HDI_raw, by = "Country", all.x = TRUE) %>%
                        select(Country, DPMean, HDI) %>%
                            arrange(desc(DPMean)) %>%
                            slice(1:15)

# Round the aggregated mean to 2 decimal places
Top15ProcrastinatorsDP$DPMean <- round(Top15ProcrastinatorsDP$DPMean, digits=2)

# Bar graph using GGPLOT for Top 15 countries in descending order for DP mean
ggplot(Top15ProcrastinatorsDP,aes(x=reorder(Country,-DPMean),y=DPMean, fill=HDICategory))+
  geom_bar(stat="identity", width=0.8, position = position_dodge(width=1))+
  coord_cartesian(xlim = c(0,16), ylim = c(3, 4.25))+
  xlab("COUNTRY") + 
  ylab("DP MEAN") + 
  ggtitle("COUNTRY BY PROCRASTINATION - DP MEAN")+
  theme(axis.text.x = element_text(size=15, angle = 90, hjust = 1, vjust = 0.5),
        axis.text.y = element_text(size=15, angle = 0, hjust = 1, vjust = 0.5),
        axis.title=element_text(size=15),
  plot.title = element_text(size=25, hjust = 0.5, vjust = 1)) +
  scale_fill_brewer(palette="Set1")
```

<img src="CaseStudy22_files/figure-html/question5b_deep_analysis-1.png" style="display: block; margin: auto;" />
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**  

**THE TOP 15 COUNTRIES WITH THE HIGHEST DP MEAN ARE:**
- Puerto Rico
- Panama
- Qatar
- Taiwan
- Lithuania
- Macao
- Sri Lanka
- Colombia
- Ecuador
- Bulgaria
- Jamaica
- Austria
- Uruguay
- Finland
- Slovenia

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

```r
#TOP 15 nations with average procrastination scores
# 5c

# Aggregate the average AIP Mean by country
AIPMeanByCountry <- select(HDIMerged, Country, AIPMean) %>%
                  filter(Country!="*Missing*") %>%
                  aggregate(AIPMean ~ Country, .,mean)

# Distinct list of Country and HDI category
HDICategoryByCountry <- distinct(select(HDIMerged, Country, HDICategory)) 

# Merge the aggregate of DPMean and the distinct country and HDI category
Top15ProcrastinatorsAIP <- merge(AIPMeanByCountry, HDICategoryByCountry, by = "Country", all.x = TRUE) %>%
                            arrange(desc(AIPMean)) %>%
                            slice(1:15)

# Top 15 nations with their HDI scores for AIP
Top15AIPWithHDI <- merge(Top15ProcrastinatorsAIP, HDI_raw, by = "Country", all.x = TRUE) %>%
                        select(Country, AIPMean, HDI) %>%
                            arrange(desc(AIPMean)) %>%
                            slice(1:15)

# Round the aggregated mean to 2 decimal places
Top15ProcrastinatorsAIP$AIPMean <- round(Top15ProcrastinatorsAIP$AIPMean, digits=2)


# Bar graph using GGPLOT for Top 15 countries in descending order for AIP mean
ggplot(Top15ProcrastinatorsAIP,aes(x=reorder(Country,-AIPMean),y=AIPMean, fill=HDICategory))+
  geom_bar(stat="identity", width=0.8, position = position_dodge(width=1))+
  coord_cartesian(xlim = c(0,16), ylim = c(3, 4.75))+
  xlab("COUNTRY") + 
  ylab("AIP MEAN") + 
  ggtitle("COUNTRY BY PROCRASTINATION - AIP MEAN")+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(size=15, angle = 90, hjust = 1, vjust = 0.5),
        axis.text.y = element_text(size=15, angle = 0, hjust = 1, vjust = 0.5),
        axis.title=element_text(size=15),
  plot.title = element_text(size=25, hjust = 0.5, vjust = 1)) +
  scale_fill_brewer(palette="Set1")
```

<img src="CaseStudy22_files/figure-html/question5c_deep_analysis-1.png" style="display: block; margin: auto;" />
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

**THE TOP 15 COUNTRIES WITH THE HIGHEST AIP MEAN ARE:**
- Taiwan
- Macao
- Cyprus
- Dominican Republic
- Qatar
- Panama
- Puerto Rico
- Iceland
- Ecuador
- Colombia
- Sri Lanka
- Turkey
- Uruguay
- Iran
- Poland

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

**THE COUNTRIES THAT ARE BOTH IN TOP 15 WITH THE HIGHEST DP MEAN AND AIP MEAN ARE:**
 
 - Taiwan
 - Macao
 - Qatar
 - Panama
 - Puerto Rico
 - Ecuador
 - Colombia
 - Sri Lanka
 - Uruguay
 
*Ecuador and Uruguay also have the same rank on both scales.*

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------** 

```r
################# 5D ##################################
# Create a data frame with age, income, and gender variables
AgeIncomeGender <- sqldf("select Age, Income, Gender
                          From HDIMerged
                          Where Income <> 'NA'")

# Regress Income on Age
mylm <- lm(Income ~ Age, data=AgeIncomeGender)

# Plot of Income vs Age
  ggplot(AgeIncomeGender, aes(x=Age, y=Income, colour=Gender)) + 
  geom_point() +
  geom_line(colour="red",aes(y=fitted(mylm)))+
  xlab("AGE") + 
  ylab("INCOME") + 
  ggtitle("AGE vs INCOME")+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(size=15, angle = 0, hjust = 1, vjust = 0.5),
        axis.text.y = element_text(size=15, angle = 0, hjust = 1, vjust = 0.5),
        axis.title=element_text(size=15),
  plot.title = element_text(size=25, hjust = 0.5, vjust = 1)) +
  scale_fill_brewer(palette="Set1")
```

<img src="CaseStudy22_files/figure-html/Question5d_create_clean_dataframe-1.png" style="display: block; margin: auto;" />
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**



```r
################# 5E ##################################
# Create a data frame with age, income, and gender variables
# Create a subset of data for comparing Life Satisfcation and HDI 

swls_hdi <- subset(HDIMerged, select = c(SWLSMean, HDI, HDICategory)) %>%
                  filter(HDI!="*Missing*") %>%
                  arrange(desc(SWLSMean))

# Transform to numeric values
swls_hdi[, 1:2] <- sapply(swls_hdi[, 1:2], as.numeric)

# # linear regression analysis
mylm <- lm(SWLSMean ~ HDI, data=swls_hdi)

# Plot a scatter plot for age and income without log transform
# Add the regression line
ggplot(swls_hdi, aes(x=HDI, y=SWLSMean)) +
  geom_point(color="red")+
  geom_smooth(method=lm, se=FALSE) +
  xlab("HUMAN DEVELOPMENT INDEX(HDI)") + 
  ylab("SWLS MEAN") + 
  ggtitle("HDI vs SWLS MEAN")+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(size=15, angle = 0, hjust = 1, vjust = 0.5),
        axis.text.y = element_text(size=15, angle = 0, hjust = 1, vjust = 0.5),
        axis.title=element_text(size=15),
  plot.title = element_text(size=25, hjust = 0.5, vjust = 1)) +
  scale_fill_brewer(palette="Set1")
```

<img src="CaseStudy22_files/figure-html/Question5e_scatter_plot-1.png" style="display: block; margin: auto;" />
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**


```r
# Aggregate the average AIP Mean by country
SWLSMeanByHDICategory <- select(HDIMerged, HDICategory, SWLSMean) %>%
                         filter(HDICategory!="*Missing*") %>%
                         aggregate(SWLSMean ~ HDICategory, .,mean)


# Bar graph using GGPLOT HDICategory vs Life Satisfaction
ggplot(SWLSMeanByHDICategory,aes(x=reorder(HDICategory,-SWLSMean),y=SWLSMean, fill=HDICategory))+
  geom_bar(stat="identity", width=0.8, position = position_dodge(width=1))+
  #coord_cartesian(xlim = c(0,16), ylim = c(3, 4.75))+
  xlab("HDI CATEGORY") + 
  ylab("SWLS MEAN") + 
  ggtitle("HDI CATEGORY vs LIFE SATISFACTION")+
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(axis.text.x = element_text(size=15, angle = 0, hjust = 1, vjust = 0.5),
        axis.text.y = element_text(size=15, angle = 0, hjust = 1, vjust = 0.5),
        axis.title=element_text(size=15),
  plot.title = element_text(size=25, hjust = 0.5, vjust = 1)) +
  scale_fill_brewer(palette="Set1")
```

<img src="CaseStudy22_files/figure-html/Question5e_barchart-1.png" style="display: block; margin: auto;" />

```r
# Log transform income to see whether it changes the relationship, it does not
# swls_hdi[, 2] <- log(swls_hdi[2],2)
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**




```r
# Create a new data.frame with columns rearranged with the CLEAN data
ProcrastinateClean <- select(HDIMerged, 
                            Age,
                            Gender,
                            Kids,
                            Education,
                            EducationAlt,
                            WrkStatus,
                            Income,
                            Occupation,
                            OccupatnAlt,
                            YearsInPos,
                            MnthsInPos,
                            CommSize,
                            Country,
                            MaritalStat,
                            Sons,
                            Daughters,
                            SelfProcrast,
                            OthrProcrast,
                            HDICategory,
                            DPMean,
                            AIPMean,
                            GPMean,
                            SWLSMean,
                            DP1,
                            DP2,
                            DP3,
                            DP4,
                            DP5,
                            AIP1,
                            AIP2,
                            AIP3,
                            AIP4,
                            AIP5,
                            AIP6,
                            AIP7,
                            AIP8,
                            AIP9,
                            AIP10,
                            AIP11,
                            AIP12,
                            AIP13,
                            AIP14,
                            AIP15,
                            GP1,
                            GP2,
                            GP3,
                            GP4,
                            GP5,
                            GP6,
                            GP7,
                            GP8,
                            GP9,
                            GP10,
                            GP11,
                            GP12,
                            GP13,
                            GP14,
                            GP15,
                            GP16,
                            GP17,
                            GP18,
                            GP19,
                            GP20,
                            SWLS1,
                            SWLS2,
                            SWLS3,
                            SWLS4,
                            SWLS5)
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

CLIENT DATA FILES ARE IN THE "DATA" FOLDER IN THE REPOSITORY

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

```r
# Write csv files to present to client

# write.csv(ProcrastinateClean, file = "ProcrastinationCLEAN.csv", row.names=FALSE )
# write.csv(procrastinate_raw,  file = "ProcrastinationRAW.csv"  , row.names=FALSE )
# write.csv(HDIMerged, file = "HDI_Merged_Data.csv", row.names=FALSE )
# write.csv(HDI_raw,   file = "HDI_Data.csv", row.names=FALSE )
# write.csv(Top15AIPWithHDI,   file = "Top15CoountriesAIP_HDI.csv", row.names=FALSE )
# write.csv(Top15DPWithHDI,   file = "Top15CoountriesDP_HDI.csv", row.names=FALSE )
```
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

## SUMMARY

This study focuses on the procrastination behaviors of a wide spectrum of regions and demographic behavior. As the United States is the leading polled country, it can be inferred (assumption we are making assuming that we actually conducted the survey on behalf of the client) that this is a representative view of the US procrastination behavior. 

Some descriptive statistics of the particiapnts give us a better understanding of the polled demographics: ~57% are female and the remaining 43% are male, mean age is ~37 and the mean income is $58,916. Of all the countries surveyed, Taiwan had the highest GP Mean score and AIP mean score, and Brunei had the highest DP mean score. 

Top 15 country rankings by AIP mean score and DP mean score can be found in the main analysis. The survey gave us a deep insight into global procrastination behaviors but it was interesting to assess whether broader factors, such as HDI, contribute to these behaviors. After scraping wikipedia and associating HDI scores and categories to country origin of surveyed participants we were able to analyze futher. Our finding is that HDI and socio-economic attributes are a driving factor of procrastination behavior.

THANK YOU FOR THIS OPPORTUNITY TO ANALYZE YOUR DATA AND PRESENT OUR FINDINGS.

CONTACT INFORMATION:
**GLOBAL CONSULTANCY, INC.**

RUHAAB MARKAS
rmarkas@mail.smu.edu
Tel: 1 (789)647 4563

KEVIN MENDONSA
kmendonsa@mail.smu.edu
Tel: 1(714)945 5874

**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------**

