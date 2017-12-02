# PROCRASTINATION - A global analysis
Kevin Mendonsa & Ruhaab Markas  
November 26, 2017  



## Introduction

You have finally finished data collection; it involved various measures of procrastination and the qualities these folks have. You plan on pitching a proposal to a company of your choosing. The details of the company, the objectives of the repo, and some of the questions are up to you; however, you should make sure that you answer at minimum the questions posed in the Tasks section. Though you get some leeway as data scientists, there are some baseline questions that the company wants to know about the data they funded. This is the resulting data set from the study, tabulated by Qualtrics. It is not entirely well-cleaned and will need some manipulation to make it useful.


#### R - Environment


```r
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

### Libraries required


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
## arrange():   dplyr, plyr
## compact():   purrr, plyr
## count():     dplyr, plyr
## failwith():  dplyr, plyr
## filter():    dplyr, stats
## id():        dplyr, plyr
## lag():       dplyr, stats
## mutate():    dplyr, plyr
## rename():    dplyr, plyr
## summarise(): dplyr, plyr
## summarize(): dplyr, plyr
```

```
## 
## Please cite as:
```

```
##  Hlavac, Marek (2015). stargazer: Well-Formatted Regression and Summary Statistics Tables.
```

```
##  R package version 5.2. http://CRAN.R-project.org/package=stargazer
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

# Set the working directory for the Data


```r
# Set the working directory for the Data
  BaseDir <- "C:\\Users\\kevinm\\Documents\\GitHub\\CaseStudy2\\source\\"

# set working directory
  setwd(BaseDir)
```

## Load the data from the csv files and from the web


```r
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
        VHigh_HDI_df <- sqldf("select 'Very High' as Category,X3 as Country,X4 as HDI
                              from VHigh_HDI_df
                              Where VHigh_HDI_df.X3 not in ('Rank', 'Country',
                              'Change in rank from previous year[1]')")
        
        High_HDI_df <- sqldf("select 'Very High' as Category,X3 as Country,X4 as HDI
                              from High_HDI_df
                              Where High_HDI_df.X3 not in ('Rank', 'Country',
                              'Change in rank from previous year[1]')")
        
        Med_HDI_df <- sqldf("select 'Very High' as Category,X3 as Country,X4 as HDI
                              from Med_HDI_df
                              Where Med_HDI_df.X3 not in ('Rank', 'Country',
                              'Change in rank from previous year[1]')")
        
        Low_HDI_df <- sqldf("select 'Very High' as Category,X3 as Country,X4 as HDI
                              from Low_HDI_df
                              Where Low_HDI_df.X3 not in ('Rank', 'Country',
                              'Change in rank from previous year[1]')")
        
# Merge all the data frames into a single data frame
        HDI_raw <- rbind(VHigh_HDI_df,
                          High_HDI_df,
                           Med_HDI_df,
                           Low_HDI_df )
```
  
# Number of Rows/Observations and Columns/Variables in the dataset

```r
 dim(procrastinate_raw)
```

```
## [1] 4264   61
```

```r
 NCOL(procrastinate_raw)
```

```
## [1] 61
```

```r
 NROW(procrastinate_raw)
```

```
## [1] 4264
```

```r
 dim(HDI_raw)
```

```
## [1] 189   3
```

```r
#  paste_meansd <- function(x, digits = 2, na.rm = TRUE){
# paste0(round(mean(x, na.rm = na.rm), digits), " (", round(sd(
# x, na.rm = na.rm), digits), ")")
# }
## The mean (sd) of a random sample of normals is `r paste_mean sd(rnorm(100))`
```
#  The mean (sd) of a random sample of normals is 0.04 (1.01)
  
# Prepare data for cleansing and transformaiton 

```r
# Add a uniqueID to each row - we may need it later
  procrastinate_raw <- rowid_to_column(procrastinate_raw, "RowID")

# Create a new data frame from raw data for cleansing but retain the original dataset for reference
  procrastinate <- procrastinate_raw
  webscrape     <- HDI_raw
```
  

# Rename the variables

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
  
# Convert character fields to a character datatype from factor


```r
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
  
  
# Add new columns for the mean of each survey mean by individual - DPMean, AIPMean, GPMean, SWLSMean


```r
  procrastinate <-  transform(procrastinate,  DPMean = rowMeans(procrastinate[,15:19], na.rm = TRUE)) %>% 
                                  transform( AIPMean = rowMeans(procrastinate[,20:34], na.rm = TRUE)) %>%
                                  transform(  GPMean = rowMeans(procrastinate[,35:54], na.rm = TRUE)) %>%
                                  transform(SWLSMean = rowMeans(procrastinate[,55:59], na.rm = TRUE)) 
  
# Round all means to 2 digits to  
  procrastinate$DPMean   <- round(procrastinate$DPMean,   digits =2)
  procrastinate$AIPMean  <- round(procrastinate$AIPMean,  digits =2)
  procrastinate$GPMean   <- round(procrastinate$GPMean,   digits =2)
  procrastinate$SWLSMean <- round(procrastinate$SWLSMean, digits =2)
```
  
                       
# Remove whitepsace by trimming the right and left sides


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
  

#  Rename values in the field "Edu" to meaningful names and load to a new column named "EducationAlt"


```r
ELSE <- TRUE
procrastinate <- procrastinate %>%
                            mutate(EducationAlt = case_when(
                                                            .$Education == "ma"      ~ "Masters",
                                                            .$Education == "deg"     ~ "Degree",
                                                            .$Education == "dip"     ~ "Diploma",
                                                            .$Education == "grade"   ~ "Elementary School",
                                                            .$Education == "high"    ~ "High School",
                                                            .$Education == "phd"     ~ "PhD",
                                                            .$Education == "lthigh"  ~ "Left High School",
                                                            .$Education == "ltuni"   ~ "Left University",
                                                            .$Education == "phd"     ~ "PhD",
                                                            ELSE                     ~ "*Missing*"
                                                           )
                                    ) 
```


### Clean other fields


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
# Change to "Title" case
procrastinate$Kids           <- str_to_title(procrastinate$Kids, locale = "en") # Replace blanks with "*Missing*"
procrastinate$SelfProcrast   <- str_to_title(procrastinate$SelfProcrast, locale = "en") # Change to "Title" case
procrastinate$OthrProcrast   <- str_to_title(procrastinate$OthrProcrast, locale = "en") # Change to "Title" case
procrastinate$OccupatnAlt    <- str_to_upper(procrastinate$OccupatnAlt, locale = "en") # Change to UPPER case
procrastinate$WrkStatus      <- str_to_title(procrastinate$WrkStatus, locale = "en")
```


### Merge the webscrape and procrastinate data frames on country doing a left join on webscrape

### Javascript to add "hover" and scroll bars to table
<script>
$(document).ready(function(){
$('[data-toggle="tooltip"]').tooltip();
});
</script>

<script>
$(document).ready(function(){
$('[data-toggle="popover"]').popover();
});
</script>


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
```

### PRELIMINARY DATA ANALYSIS

1. For the purpose of this analysis we have eliminated all participants under 18 years of age.  This will permit a focus on primarily employment eligible individuals.  Furthermore, we have also excluded all participants 80 years and above for a similar purpose.The intention is not to skew our analysis in any way with bias from participants 18 and below and 80 and above.  

DESCRIPTIVE STATISTICS OF KEY FACTORS

AGE


```r
# summary(HDIMerged$Age)
```
The Mean Age with a 95% confidence interval is NA

INCOME

```r
summary(HDIMerged$Income)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##       0   15000   45000   58916   67500  250000     548
```
HDI

```r
summary(HDIMerged$HDI)
```

```
##    Length     Class      Mode 
##      4264 character character
```

SURVEY MEANS - DP, GP, AIP, SWLS

```r
summary(HDIMerged$DPMean)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.800   2.000   2.600   2.598   3.200   6.000
```

```r
summary(HDIMerged$GPMean)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.750   3.250   3.227   3.750   5.000
```

```r
summary(HDIMerged$AIPMean)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.330   2.930   2.936   3.530   5.000
```

```r
summary(HDIMerged$SWLSMean)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.600   3.200   3.205   3.800   5.000
```




```r
# Exclude all observations where the participant is under 18 years of age and 80 and over
# Removed the age group 80 and above - Provide reason
HDIMerged <- filter(HDIMerged, Age > 18) %>%
                filter(Age < 79 )

# Histogram for AIPMean
qplot(HDIMerged$AIPMean,
      geom="histogram",
      binwidth = .25,  
      main = "Histogram of AIP Mean", 
      xlab = "AIP Mean",  
      fill=I("blue"), 
      col=I("red"),
      xlim=c(0,5.5),
      alpha=I(.4))
```

![](CaseStudy22_files/figure-html/histograms-1.png)<!-- -->

```r
# Histogram for GPMean
ggplot(data=HDIMerged, aes(x=HDIMerged$GPMean)) + 
  geom_histogram(binwidth = .25, 
                 col="red", 
                 fill="green", 
                 alpha = .2) + 
  labs(title="Histogram of GP Mean", x="GP Mean", y="Count") + 
  xlim(c(0,5)) + 
  ylim(c(0,550)) +
  theme(plot.title = element_text(hjust = 0.5, vjust=0.5))
```

![](CaseStudy22_files/figure-html/histograms-2.png)<!-- -->

```r
# Histogram for SWLSMean
ggplot(data=HDIMerged, aes(x=HDIMerged$SWLSMean)) + 
  geom_histogram(binwidth = .25, 
                 col="blue", 
                 fill="red", 
                 alpha = .2) + 
  labs(title="Histogram of SWLS Mean", x="SWLS Mean", y="Count") + 
  xlim(c(0,5)) + 
  ylim(c(0,900)) +
  theme(plot.title = element_text(hjust = 0.5, vjust=0.5))
```

![](CaseStudy22_files/figure-html/histograms-3.png)<!-- -->

## The distribution of the AIP Mean and the GP Mean and
# The distribution for the AIP mean has some appearence of a bi-modal distribution but it does fit a normal distribution fairly well. The distribution for the for the GP mean has some left skew but still confirms to a normal distribution.



```r
GenderFreq <- table(HDIMerged$Gender) %>%
  print()
```

```
## 
## *Missing*    Female      Male 
##         6      2295      1708
```

```r
WrkStatusFreq <- table(HDIMerged$WrkStatus)%>%
  print()
```

```
## 
##  *Missing*  Full-Time  Part-Time    Retired    Student Unemployed 
##         42       2259        463        151        837        257
```

```r
OccupationAltFreq <- table(HDIMerged$OccupatnAlt) %>%
  print()  
```

```
## 
##                                *AMBIGUOUS* 
##                                         22 
##                                  *MISSING* 
##                                       2647 
##                  ACADEMIC - ADMINISTRATION 
##                                          6 
##       ACADEMIC - ADMINISTRATION (DIRECTOR) 
##                                          1 
##                                 ACCOUNTANT 
##                                         10 
##                                    ACTRESS 
##                                          1 
##                              ACUPUNCTURIST 
##                                          1 
##                            ADMIN ASSISTANT 
##                                          5 
##                   ADMINISTRATIVE ASSISTANT 
##                                          1 
##                              ADMINISTRATOR 
##                                         11 
##                    ADMINSTRATIVE ASSISTANT 
##                                          6 
##                                 ADULT CARE 
##                                          1 
##                                 AGRONOMIST 
##                                          1 
##                     AIRPORT GROUND HANDLER 
##                                          1 
##                                    ANALYST 
##                                          5 
##                             ANTIQUE DEALER 
##                                          1 
##                                  ARCHITECT 
##                                          4 
##                               ART DIRECTOR 
##                                          2 
##                                     ARTIST 
##                                          9 
##                           ARTIST - JEWELRY 
##                                          1 
##                                  ASSISTANT 
##                                          1 
##                        ASSISTANT PROFESSOR 
##                                          3 
##                                  ASSOCIATE 
##                                          2 
##                              ASTROHYSICIST 
##                                          1 
##                                   ATTORNEY 
##                                         57 
## ATTORNEY - SELF EMPLOYED FOR 2 YEARS Â<U+0080><U+0093> F 
##                                          1 
##                     ATTORNEY Â<U+0080><U+0093> ASSOCIATE 
##                                          1 
##                        AVIATION SPECIALIST 
##                                          1 
##                                    BANKING 
##                                          2 
##             BANKING - INVESTMENT ASSISTANT 
##                                          1 
##             BANKING - INVESTMENT ASSOCIATE 
##                                          1 
##                BANKING - INVESTMENT BANKER 
##                                          1 
##             BANKING - INVESTMENT COUNSELOR 
##                                          1 
##                           BANKING - TELLER 
##                                          3 
##                                  BARTENDER 
##                                          1 
##                                  BIOLOGIST 
##                                          1 
##                                 BOOKKEEPER 
##                                          3 
##                                 BOOKSELLER 
##                                          1 
##                  BOX OFFICE REPRESENTATIVE 
##                                          1 
##                                  BRAILLIST 
##                                          1 
##                             BUDGET ANALYST 
##                                          1 
##                        BUSINESS CONSULTANT 
##                                          2 
##            BUSINESS DEVELOPMENT - DIRECTOR 
##                                          1 
##             BUSINESS OWNER / SELF EMPLOYED 
##                                         20 
##                                      BUYER 
##                                          1 
##                       BUYER - ONLINE MEDIA 
##                                          1 
##                               CAD OPERATOR 
##                                          1 
##                             CAD TECHNICIAN 
##                                          1 
##                         CAMERA COORDINATOR 
##                                          1 
##                CASE COORDINATOR - CONSUMER 
##                                          2 
##                               CASE MANAGER 
##                                          1 
##                                    CASHIER 
##                                          1 
##             CATALOGUER /  FREELANCE ARTIST 
##                                          1 
##                                        CEO 
##                                          5 
##                                        CFO 
##                                          1 
##                                   CHAIRMAN 
##                                          1 
##                             CHIEF OF STAFF 
##                                          2 
##                               CHIROPRACTOR 
##                                          1 
##                              CIVIL SERVANT 
##                                          3 
##                                      CLERK 
##                                          5 
##                      CLINICAL PSYCHOLOGIST 
##                                          1 
##                CLINICAL RESEARCH ASSISTANT 
##                                          1 
##                   CLINICAL TRIAL ASSISTANT 
##                                          1 
##    CLUTTER CLEARER,  VIDEO EDITOR, CATERER 
##                                          2 
##                                COLLECTIONS 
##                                          1 
##                             COMMUNICATIONS 
##                                          2 
##                COMMUNICATIONS & PUBLISHING 
##                                          1 
##                               CONSTRUCTION 
##                                          1 
##                    CONSTRUCTION MANAGEMENT 
##                                          1 
##                                 CONSULTANT 
##                                         12 
##                             CONSULTANT SR. 
##                                          1 
##                         CONSULTING MANAGER 
##                                          1 
##             CONTRACT MANAGEMENT - DIRECTOR 
##                                          1 
##               CONTRACT/PROPOSAL - DIRECTOR 
##                                          1 
##                            COPY SUPERVISOR 
##                                          1 
##                                COPY WRITER 
##                                          2 
##                          CORPORATE TRAINER 
##                                          2 
##                        CORRECTIONS OFFICER 
##                                          1 
##             CORRECTIONS OFFICER - JUVENILE 
##                                          1 
##                                  COUNSELOR 
##                                          2 
##                   COUNSELOR - CAREER COACH 
##                                          1 
##               COUNSELOR - CAREER PLACEMENT 
##                                          1 
##                         COUNSELOR - SCHOOL 
##                                          1 
##                        CREATIVE CONSULTANT 
##                                          1 
##                          CREATIVE DIRECTOR 
##                                          2 
##                           CUSTOMER SERVICE 
##                                          9 
##                              DANCE TEACHER 
##                                          1 
##            DENTAL & DISABILITY COORDINATOR 
##                                          1 
##                                    DENTIST 
##                                          2 
##                            DEPUTY DIRECTOR 
##                                          3 
##                                   DESIGNER 
##                                          4 
##                                  DIETITIAN 
##                                          1 
##                       DIETITIAN - CLINICAL 
##                                          1 
##                                   DIRECTOR 
##                                         13 
##                 DIRECTOR,SOCIAL DVELOPMENT 
##                                          1 
##                                 DISHWASHER 
##                                          1 
##   DOCTORAL CANDIDATE!!!  NO WONDER I'M DOI 
##                                          1 
##                                     DRIVER 
##                                          3 
##                                DRUG SAFETY 
##                                          1 
##                         ECOLOGY TECHNICIAN 
##                                          1 
##                                  ECONOMIST 
##                                          2 
##                                     EDITOR 
##                                         21 
##                         EDITOR - FREELANCE 
##                                          1 
##                  EDITOR - SPECIAL PROJECTS 
##                                          1 
##                          ELECTION SERVICES 
##                                          1 
##                                ELECTRICIAN 
##                                          1 
##                      ELECTRONIC TECHNICIAN 
##                                          1 
##                                        EMT 
##                                          1 
##                                   ENGINEER 
##                                         32 
##                           ENGINEER - AUDIO 
##                                          1 
##                     ENGINEER - DEVELOPMENT 
##                                          1 
##                      ENGINEER - MECHANICAL 
##                                          1 
##                         ENGINEER - PROCESS 
##                                          1 
##                                  ENOLOGIST 
##                                          1 
##                                ENTERTAINER 
##                                          1 
##         ENVIRONMENTAL - ANALYTICAL MANAGER 
##                                          1 
##       ENVIRONMENTAL - EDUCATION/NON PROFIT 
##                                          1 
##                ENVIRONMENTAL - EHS MANAGER 
##                                          1 
##                      ENVIRONMENTAL ANALYST 
##                                          1 
##                     ENVIRONMENTAL ENGINEER 
##                                          1 
##                   ENVIRONMENTAL SPECIALIST 
##                                          1 
##                                  EXECUTIVE 
##                                          1 
##                        EXECUTIVE ASSISTANT 
##                                          2 
##                         EXECUTIVE DIRECTOR 
##                                          2 
##                          EXECUTIVE OFFICER 
##                                          1 
##                                FACILITATOR 
##                                          1 
##                      FACILITIES MANAGEMENT 
##                                          1 
##                               FARM MANAGER 
##                                          1 
##                          FIELD COORDINATOR 
##                                          1 
##                    FILM - CASTING DIRECTOR 
##                                          1 
##                              FILM - EDITOR 
##                                          1 
##                               FILM - MAKER 
##                                          1 
##                               FILM - OTHER 
##                                          1 
##                            FILM - PRODUCER 
##                                          1 
##               FILM/TV - ASSOCIATE DIRECTOR 
##                                          1 
##               FILM/TV - ASSOCIATE PRODUCER 
##                                          1 
##                                    FINANCE 
##                                          5 
##                          FINANCIAL ADVISOR 
##                                         11 
##                          FINANCIAL ANALYST 
##                                          2 
##                       FINANCIAL CONSULTANT 
##                                          1 
##                       FINANCIAL CONTROLLER 
##                                          2 
##                          FINANCIAL OFFICER 
##                                          1 
##                     FINANCIAL RISK MANAGER 
##                                          1 
##                         FITNESS INSTRUCTOR 
##                                          1 
##       FITNESS INSTRUCTOR - WELLNESS MENTOR 
##                                          1 
##                             FLIGHT SURGEON 
##                                          1 
##                   FOOD DEPARTMENT DIRECTOR 
##                                          1 
##                    FOOD SERVICE SUPERVISOR 
##                                          1 
##                            FOREIGN AFFAIRS 
##                                          2 
##                 FOREIGN AFFAIRS SPECIALIST 
##                                          1 
##                                     FRAMER 
##                                          1 
##             FURNITURE MAKER, HOME RESTORER 
##                                          1 
##                                  GEOLOGIST 
##                                          2 
##                               GEOPHYSICIST 
##                                          1 
##                         GRADUATE ASSISTANT 
##                                          5 
##              GRADUATE ASSISTANT - RESEARCH 
##                                          2 
##                       GRANTS ADMINISTRATOR 
##                                          1 
##                           GRAPHIC DESIGNER 
##                                         11 
##          GROCERY STORE - PRODUCE ASSOCIATE 
##                                          1 
##                     GROCERY STORE SALESMAN 
##                                          1 
##                              GROUNDSKEEPER 
##                                          1 
##                                 HEALTHCARE 
##                                          1 
##                    HEALTHCARE - CONSULTANT 
##                                          1 
##                                 HOME-MAKER 
##                                          1 
##                                 HOME MAKER 
##                                         29 
##                   HOSPITALITY - DESK CLERK 
##                                          1 
##                 HOSPITALITY - HOUSEKEEPING 
##                                          1 
##                    HOSPITALITY - INNKEEPER 
##                                          1 
##                              HR CONSULTANT 
##                                          1 
##                              HR GENERALIST 
##                                          1 
##                                 HR MANAGER 
##                                          4 
##                                  HVAC TECH 
##                                          1 
##                               ICT DIRECTOR 
##                                          1 
##                         INSTRUCTOR - COACH 
##                                          1 
##              INSTRUCTOR - ONLINE ASSISTANT 
##                                          1 
##                                  INSURANCE 
##                                          2 
##                            INSURANCE AGENT 
##                                          4 
##               INSURANCE BROKER'S ASSISTANT 
##                                          1 
##                INSURANCE CLAIMS SUPERVISOR 
##                                          1 
##                      INSURANCE COORDINATOR 
##                                          1 
##                   INVESTIGATIVE SPECIALIST 
##                                          1 
##                                         IT 
##                                          3 
##                             IT - ASSISTANT 
##                                          1 
##                          IT - CIO (DEPUTY) 
##                                          1 
##                            IT - CONSULTANT 
##                                          5 
##                                   IT - CTO 
##                                          1 
##                              IT - DIRECTOR 
##                                          1 
##                           IT - DW ENGINEER 
##                                          1 
##                               IT - MANAGER 
##                                          2 
##                     IT - SOFTWARE ENGINEER 
##                                          5 
##                      IT - SUPPORT ENGINEER 
##                                          3 
##                       IT - SYSTEMS ANALYST 
##                                          6 
##                  IT - TRAINING COORDINATOR 
##                                          1 
##                           IT ADMINISTRATOR 
##                                          2 
##                                 IT ANALYST 
##                                          1 
##                               IT ASSISTANT 
##                                          1 
##                              IT CONSULTANT 
##                                          4 
##                                IT DIRECTOR 
##                                          2 
##                                IT ENGINEER 
##                                          1 
##                                 IT MANAGER 
##                                          1 
##                        IT NETWORK ENGINEER 
##                                          3 
##                 IT PROGRAMMER - CONSULTANT 
##                                          1 
##                     IT SECURITY CONSULTANT 
##                                          1 
##                       IT SOFTWARE ENGINEER 
##                                         27 
##                   IT SOFTWARE PROFESSIONAL 
##                                          2 
##                              IT SPECIALIST 
##                                          2 
##                        IT SUPPORT ENGINEER 
##                                          2 
##                         IT SYSTEMS ANALYST 
##                                          7 
##                                    JANITOR 
##                                          1 
##                                 JOURNALIST 
##                                          8 
##                             LAB  ASSISTANT 
##                                          1 
##                               LAB DIRECTOR 
##                                          1 
##                             LAB TECHNICIAN 
##                                          2 
##                 LABOR RELATIONS SPECIALIST 
##                                          1 
##                         LANDSCAPE DESIGNER 
##                                          1 
##                LANGUAGE - PROGRAM DIRECTOR 
##                                          1 
##              LANGUAGE AND SPEECH ASSISTANT 
##                                          1 
##                  LANGUAGE SERVICE PROVIDER 
##                                          1 
##                           LANGUAGE TRAINER 
##                                          1 
##                            LAW ENFORCEMENT 
##                                          3 
##                            LEGAL ASSISTANT 
##                                          3 
##           LEGAL ASSISTANT / OFFICE MANAGER 
##                                          1 
##                                LEGAL CLERK 
##                                          2 
##                            LEGAL SECRETARY 
##                                          1 
##                        LEGISLATION ANALYST 
##                                          1 
##                             LETTER CARRIER 
##                                          2 
##                                  LIBRARIAN 
##                                         12 
##                        LIBRARIAN ASSISTANT 
##                                          1 
##            LICENSED PROFESSIONAL COUNSELOR 
##                                          1 
##                                 LIFE GUARD 
##                                          1 
##                      MAINTENANCE TECHNICAN 
##                                          1 
##                      MANAGEMENT CONSULTANT 
##                                          2 
##                                    MANAGER 
##                                         33 
##                  MANAGER,INTERACITVE MEDIA 
##                                          1 
##                              MANUFACTURING 
##                                          1 
##                                  MARKETING 
##                                         21 
##                 MARKETING - COMMUNICATIONS 
##                                          1 
##                       MARKETING COPYWRITER 
##                                          2 
##                 MARKETING RESEARCH ANALYST 
##                                          7 
##                          MASSAGE THERAPIST 
##                                          1 
##                    MASTER CONTROL OPERATOR 
##                                          1 
##              MEDIA & INTERNET - CONSULTANT 
##                                          1 
##                           MEDIA CONSULTANT 
##                                          1 
##                    MEDIA RELATIONS MANAGER 
##                                          1 
##            MEDIA RELATIONS/SCIENCE WRITING 
##                                          1 
##                                    MEDICAL 
##                                          1 
##           MEDICAL / PUBLIC HEALTH EDUCATOR 
##                                          1 
##                         MEDICAL LABORATORY 
##                                          1 
##                       MEDICAL PRACTITIONER 
##                                          1 
##                        MEDICAL SONOGRAPHER 
##                                          1 
##                   MEDICAL TRANSCRIPTIONIST 
##                                          1 
##               MENTOR/SPECIAL EVENTS INTERN 
##                                          1 
##              MERCHANDISER - PHARMACEUTICAL 
##                                          1 
##                                   MILITARY 
##                                          1 
##    MILITARY - EXPLOSIVE ORDINANCE DISPOSAL 
##                                          1 
##                                      MOVER 
##                                          1 
##                       MULTIMEDIA DEVELOPER 
##                                          1 
##                              MUSEUM DOCENT 
##                                          1 
##                                   MUSICIAN 
##                                          5 
##                                      NANNY 
##                                          6 
##                         NEWSPAPER DELIVERY 
##                                          1 
##    NIGHT DISPATCH SUPERVISOR  (IT'S JUST A 
##                                          1 
##                      NON-PROFIT CONSULTANT 
##                                          1 
##                      NON PROFIT - DIRECTOR 
##                                          2 
##                                      NURSE 
##                                         13 
##                                 NURSE - RN 
##                                          4 
##              NURSING - CERTIFIED ASSISTANT 
##                                          1 
## NURSING - CERTIFIED REGISTERED ANESTHETIST 
##                                          1 
##               NURSING - LICENSED PRACTICAL 
##                                          1 
##                               NURSING HOME 
##                                          1 
##                               OFFICE ADMIN 
##                                          2 
##                           OFFICE ASSISTANT 
##                                          1 
##                             OFFICE MANAGER 
##                                          3 
##                   OPERATIONS - COORDINATOR 
##                                          1 
##                      OPERATIONS - DIRECTOR 
##                                          1 
##    OPERATIONS - PRODUCTION SUPPORT ANALYST 
##                                          1 
##                            OPERATIONS & QA 
##                                          1 
##                         OPERATIONS MANAGER 
##                                          4 
##                   ORGANIZER - PROFESSIONAL 
##                                          1 
##             OUTDOOR RECREATION COORDINATOR 
##                                          1 
##                                  PARALEGAL 
##                                          2 
##                PASTOR ; LIFE COACH  CLERGY 
##                                          5 
##                                  PATHOLOGY 
##                                          1 
##                         PCA - QUADRIPLEGIC 
##                                          1 
##                           PERSONAL TRAINER 
##                                          1 
##                                 PHARMACIST 
##                                          4 
##                               PHOTOGRAPHER 
##                                          3 
##                PHYSICAL SCIENCE TECHNICIAN 
##                                          1 
##                         PHYSICAL THERAPIST 
##                                          1 
##                                  PHYSICIAN 
##                                         17 
##                 PHYSICIAN - EPIDEMIOLOGIST 
##                                          2 
##                         PHYSICIAN - INTERN 
##                                          1 
##                      PHYSICIAN - POST GRAD 
##                                          1 
##                       PHYSICIAN - RESEARCH 
##                                          1 
##                                  PHYSICIST 
##                                          1 
##                             PHYSIOTHERAPST 
##                                          1 
##                           PLANNER - CAMPUS 
##                                          1 
##                         PLANNER - LAND USE 
##                                          1 
##                             PLANNER - TOWN 
##                                          1 
##                            PLANNER - URBAN 
##                                          1 
##               PLANT ENGINEERING SUPERVISOR 
##                                          1 
##                             POLICY ADVISOR 
##                                          1 
##                             POLICY ANALYST 
##                                          2 
##                                  PRESIDENT 
##                                          8 
##                            PRESIDENT - NGO 
##                                          1 
##                              PRESS OFFICER 
##                                          2 
##                                     PRIEST 
##                                          1 
##                   PRIVATE EQUITY PRINCIPAL 
##                                          1 
##         PRO POKER PLAYER /   WEBSITE OWNER 
##                                          1 
##                          PROBATION OFFICER 
##                                          1 
##                 PRODUCT FIELD TEST MANAGER 
##                                          1 
##                                  PROFESSOR 
##                                         61 
##                            PROGRAM ANALYST 
##                                          1 
##                          PROGRAM ASSISTANT 
##                                          1 
##                        PROGRAM COORDINATOR 
##                                          2 
##             PROGRAM DEVELOPMENT SPECIALIST 
##                                          1 
##                           PROGRAM DIRECTOR 
##                                          1 
##   PROGRAM DIRECTOR AT A NON-PROFIT ORGANIZ 
##                                          1 
##                            PROGRAM MANAGER 
##                                          1 
##        PROGRAM MANAGER AND ACTING DIRECTOR 
##                                          1 
##                            PROGRAM OFFICER 
##                                          1 
##                         PROGRAM SPECIALIST 
##                                          1 
##                            PROJECT MANAGER 
##                                         12 
##                                PROOFREADER 
##                                          1 
##           PSYCHIATRIST IN PRIVATE PRACTICE 
##                                          1 
##                               PSYCHOLOGIST 
##                                          7 
##                            PSYCHOTHERAPIST 
##                                          3 
##                              PUBLIC HEALTH 
##                                          1 
##                 PUBLIC HEALTH - CONSULTANT 
##                                          1 
##          PUBLIC INFORMATION - DEPUTY CHIEF 
##                                          1 
##                           PUBLIC RELATIONS 
##                                          4 
##                                 PUBLISHING 
##                                          1 
##                            QUALITY MANAGER 
##                                          1 
##                      QUOTATIONS SPECIALIST 
##                                          1 
##                          REAL ESTATE AGENT 
##                                          3 
##                      REAL ESTATE APPRAISER 
##                                          1 
##                      REAL ESTATE DEVELOPER 
##                                          1 
##                                    REALTOR 
##                                          2 
##                               RECEPTIONIST 
##                                          3 
##                            RECORDS ANALYST 
##                                          1 
##                         RECREATIONAL STAFF 
##                                          1 
##                         REGULATORY AFFAIRS 
##                                          1 
##                                  RENOVATOR 
##                                          1 
##                         REPORTER - TRAFFIC 
##                                          1 
##                     RESEARCH / GIS ANALYST 
##                                          1 
##                           RESEARCH ANALYST 
##                                          1 
##                         RESEARCH ASSISTANT 
##                                          9 
##                         RESEARCH ASSOCIATE 
##                                          4 
##                       RESEARCH COORDINATOR 
##                                          1 
##                            RESEARCH INTERN 
##                                          1 
##                           RESEARCH MANAGER 
##                                          1 
##                           RESEARCH SCHOLAR 
##                                          1 
##                         RESEARCH SCIENTIST 
##                                          8 
##                        RESEARCH SPECIALIST 
##                                          1 
##                        RESEARCH TECHNICIAN 
##                                          1 
##                RESEARCH/TEACHING ASSISTANT 
##                                          1 
##                                 RESEARCHER 
##                                          3 
##                      RESEARCHER - GRADUATE 
##                                          1 
##                     RESEARCHER - PHYSICIAN 
##                                          1 
##                 RESEARCHER - POST DOCTORAL 
##                                          1 
##          RESIDENTIAL SERVICES - SUPERVISOR 
##                                          1 
##            RESIDENTIAL SERVICES SUPERVISOR 
##                                          1 
##                    RESPIRATORY - THERAPIST 
##                                          1 
##                      RESPIRATORY THERAPIST 
##                                          1 
##                   RESTAURANT - FOOD SERVER 
##                                         10 
##                  RESTAURANT - HOST/HOSTESS 
##                                          2 
##                     RESTAURANT & BAR OWNER 
##                                          1 
##                RESTAURANT OPERATIONS - MGR 
##                                          1 
##              RESTAURANT OPERATIONS MANAGER 
##                                          1 
##                                     RETAIL 
##                                          5 
##                                    RETIRED 
##                                         26 
##                                      SALES 
##                                          4 
##                    SALES - ACCOUNT MANAGER 
##                                          1 
##                    SALES - ACCOUNT PLANNER 
##                                          1 
##                        SALES - ACCOUNT REP 
##                                          1 
##      SALES - CLIENT RELATIONSHIP ASSISTANT 
##                                          1 
##                            SALES - MANAGER 
##                                          1 
##                            SALES - MEDICAL 
##                                          1 
##                           SALES - SOFTWARE 
##                                          2 
##                            SALES EXECUTIVE 
##                                          1 
##                               SALES EXPERT 
##                                          1 
##                            SALES INSURANCE 
##                                          1 
##                              SALES MANAGER 
##                                          3 
##                                  SALES REP 
##                                          3 
##                      SALES/ DAYCARE WORKER 
##                                          1 
##                    SCIENTIFIC AFFAIRS - VP 
##                                          1 
##                                  SCIENTIST 
##                                         12 
##                         SCIENTIST - ROCKET 
##                                          1 
##                                  SECRETARY 
##                                          1 
##                              SELF EMPLOYED 
##                                          1 
##                       SENIOR GRANT OFFICER 
##                                          1 
##                       SERVICE CO-ORDINATOR 
##                                          1 
##                               SET DESIGNER 
##                                          1 
##                    SET LIGHTING TECHNICIAN 
##                                          1 
##                    SOCIAL MEDIA CONSULTANT 
##                                          1 
##                      SOCIAL POLICY ANALYST 
##                                          1 
##                         SOCIAL WORK INTERN 
##                                          1 
##                              SOCIAL WORKER 
##                                          7 
##                   SOCIAL WORKER - HANDICAP 
##                                          1 
##                  SPEAKER AUTHOR CONSULTANT 
##                                          1 
##                              SPEAKER/ACTOR 
##                                          1 
##   SPECIAL EDUCATION ADMINISTRATIVE ASSISTA 
##                                          1 
##                  SPECIAL EDUCATION TEACHER 
##                                          4 
##                               STATISTICIAN 
##                                          1 
##                            STEAMSHIP AGENT 
##                                          1 
##                                    STOCKER 
##                                          2 
##                                    STUDENT 
##                                          9 
##                    STUDENT - POST DOCTORAL 
##                                          2 
##                STUDENT / WORKING PART-TIME 
##                                          1 
##       STUDENT AND ADMINISTRATIVE ASSISTANT 
##                                          1 
##            STUDENT AND PART TIME SECRETARY 
##                                          1 
##                STUDENT AND PRIVATE CURATOR 
##                                          1 
##        STUDENT CHILDHOOD AND YOUTH STUDIES 
##                                          1 
##  STUDENT FYSIOTHERAPY /HOME CARE / MASSAGE 
##                                          1 
##      STUDENT PART-TIME AND SALES FULL-TIME 
##                                          1 
##                            STUDENT/BARMAID 
##                                          1 
##                           STUDENT/IMVESTOR 
##                                          1 
##                             STUDENT/RETAIL 
##                                          1 
##                            STUDENT/TEACHER 
##                                          1 
##                             STUDENT/WAITER 
##                                          1 
##                                    SURGEON 
##                                          1 
##                         SURGEON - RESIDENT 
##                                          1 
##                                TAX AUDITOR 
##                                          1 
##                             TAX CONSULTANT 
##                                          1 
##                               TAX EXAMINER 
##                                          1 
##                                    TEACHER 
##                                         85 
##     TEACHER'S ASSISTANT/AFTERSCHOOL LEADER 
##                                          1 
##                    TEACHER / ADMINISTRATOR 
##                                          1 
##     TEACHER AND FULL TIME DOCTORAL STUDENT 
##                                          1 
##                          TEACHER ASSISTANT 
##                                          3 
##        TEACHING ASSISTANT/GRADUATE STUDENT 
##                                          1 
##                           TECH ANALYST/GIS 
##                                          1 
##                      TECHNICAL COORDINATOR 
##                                          1 
##                         TECHNICAL DIRECTOR 
##                                          1 
##                          TECHNICAL OFFICER 
##                                          1 
##                          TECHNICAL SUPPORT 
##                                          1 
##                      TECHNICAL SUPPORT REP 
##                                          1 
##                          TECHNICAL TRAINER 
##                                          1 
##                           TECHNICAL WRITER 
##                                          4 
##    TECHNOLOGY CURRICULUM DEVELOPER SCIENCE 
##                                          1 
##                        TELEVISION DIRECTOR 
##                                          1 
##                        TELEVISION PRODUCER 
##                                          1 
##                    THEATER ARTIST/ TEACHER 
##                                          1 
##                    THEATER GENERAL MANAGER 
##                                          1 
##                         THERAPIST - ENERGY 
##                                          1 
##                         THERAPIST - FAMILY 
##                                          1 
##                                 TOUR GUIDE 
##                                          1 
##                                 TOWN CLERK 
##                                          1 
##                                     TRADER 
##                                          1 
##                       TRAINING -  SOFTWARE 
##                                          1 
##                       TRAINING COORDINATOR 
##                                          2 
##                                 TRANSLATOR 
##                                          7 
##                   TRANSLATOR / INTERPRETER 
##                                          1 
##             TREATMENT SUPPORT CO-ORDINATOR 
##                                          1 
##                                      TUTOR 
##                                          5 
##                    TV BROADCAST TECHNICIAN 
##                                          1 
##                 TV NEWS EXECUTIVE PRODUCER 
##                                          1 
##                                 UNEMPLOYED 
##                                         18 
##                    VETERANS REPRESENTATIVE 
##                                          1 
##                               VETERINARIAN 
##                                          2 
##                             VICE-PRESIDENT 
##                                          2 
##                             VICE PRESIDENT 
##                                          2 
##            VICE PRESIDENT / PROGRAM OFFICE 
##                                          1 
##                               VIDEOGRAPHER 
##                                          1 
##                              VISUAL ARTIST 
##                                          1 
##                         VOLUNTEER DIRECTOR 
##                                          1 
##             VOLUNTEER MENTAL HEALTH WORKER 
##                                          1 
##                                  WAREHOUSE 
##                                          1 
##                       WAREHOUSE SUPERVISOR 
##                                          1 
##                                WAREHOUSING 
##                                          1 
##                         WEB COMMUNICATIONS 
##                                          1 
##                               WEB DESIGNER 
##                                          4 
##                 WEBMASTER / PRINT DESIGNER 
##                                          1 
##                               WIG DESIGNER 
##                                          1 
##                                     WRITER 
##                                         20 
##                  WRITER - SCIENCE (INTERN) 
##                                          1 
##                           WRITER - TESTING 
##                                          1 
##     WRITER & DIRECTOR OF CONTENT SOLUTIONS 
##                                          1 
##                           WRITER / EDUCTOR 
##                                          1 
##             WRITER / LECTURER / CONSULTANT 
##                                          1 
##          WRITER / WEB DESIGNER/ WEB-MASTER 
##                                          1 
##           WRITER AND MANAGEMENT CONSULTANT 
##                                          1 
##                  WRITER/AUTHOR - FREELANCE 
##                                          2 
##                              WRITER/EDITOR 
##                                          2 
##                     WRITER/EDITOR/MUSICIAN 
##                                          1 
##                            WRITER/MUSICIAN 
##                                          1 
##                         WRITING CONSULTANT 
##                                          2 
##                               YOGA TEACHER 
##                                          1
```

```r
Country <- sqldf ("select Country, Count(Country) as Count
                    from HDIMerged 
                    Where Country<>'*Missing*'
                    Group by Country 
                    Order by Country") %>%
            print()
```

```
##               Country Count
## 1         Afghanistan     3
## 2             Albania     2
## 3             Algeria     3
## 4             Andorra     1
## 5             Antigua     1
## 6           Argentina     3
## 7           Australia    99
## 8             Austria     3
## 9             Bahamas     1
## 10           Barbados     1
## 11            Belgium     9
## 12            Bermuda     2
## 13            Bolivia     1
## 14           Botswana     1
## 15             Brazil    20
## 16           Bulgaria     2
## 17             Canada   243
## 18              Chile     4
## 19              China    12
## 20           Colombia     2
## 21            Croatia     4
## 22             Cyprus     1
## 23     Czech Republic     3
## 24            Denmark     9
## 25 Dominican Republic     1
## 26            Ecuador     3
## 27              Egypt     1
## 28        El Salvador     1
## 29            Finland    12
## 30             France    13
## 31            Germany    36
## 32              Ghana     2
## 33             Greece    10
## 34               Guam     1
## 35             Guyana     1
## 36          Hong Kong     7
## 37            Hungary     1
## 38            Iceland     1
## 39              India    78
## 40               Iran     2
## 41            Ireland    19
## 42             Israel    19
## 43              Italy    60
## 44            Jamaica     1
## 45              Japan    13
## 46              Kenya     1
## 47          Lithuania     1
## 48         Luxembourg     1
## 49              Macao     1
## 50          Macedonia     1
## 51           Malaysia     4
## 52              Malta     2
## 53             Mexico    11
## 54            Morocco     1
## 55            Myanmar     1
## 56        Netherlands    18
## 57        New Zealand    12
## 58          Nicaragua     1
## 59             Norway    14
## 60           Pakistan     1
## 61             Panama     1
## 62               Peru     2
## 63        Philippines    11
## 64             Poland     5
## 65           Portugal     7
## 66        Puerto Rico     3
## 67              Qatar     1
## 68            Romania     5
## 69             Russia     1
## 70       Saudi Arabia     2
## 71          Singapore     4
## 72           Slovenia     6
## 73       South Africa    12
## 74        South Korea     2
## 75              Spain    13
## 76          Sri Lanka     1
## 77             Sweden    15
## 78        Switzerland    11
## 79             Taiwan     1
## 80           Thailand     2
## 81             Turkey     9
## 82            Ukraine     2
## 83     United Kingdom   177
## 84      United States  2767
## 85            Uruguay     3
## 86          Venezuela     2
## 87            Vietnam     1
## 88         Yugoslavia     2
```

```r
Matched <- sqldf ("select Count(1) as 'Matched'
                    from HDIMerged 
                    Where SelfProcrast=OthrProcrast
                    ")

dt <- mtcars[1:5, 1:6]
kable(dt, "html")
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
dt %>%
kable("html") %>%
kable_styling()
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling(bootstrap_options = c("striped", "hover"))
```

<table class="table table-striped table-hover" style="margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling(bootstrap_options = c("striped", "hover",
"condensed"))
```

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling(bootstrap_options = c("striped", "hover",
"condensed", "responsive"))
```

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling(bootstrap_options = "striped", full_width
= F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling(bootstrap_options = "striped", full_width
= F, position = "left")
```

<table class="table table-striped" style="width: auto !important; ">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling(bootstrap_options = "striped", full_width
= F, position = "float_right")
```

<table class="table table-striped" style="width: auto !important; float: right; margin-left: 10px;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling(bootstrap_options = "striped", font_size =
7)
```

<table class="table table-striped" style="font-size: 7px; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
text_tbl <- data.frame(
Items = c("Item 1", "Item 2", "Item 3"),
Features = c(
"Lorem ipsum dolor sit amet, consectetur adipiscing el
it. Proin vehicula tempor ex. Morbi malesuada sagittis tur
pis, at venenatis nisl luctus a. ",
"In eu urna at magna luctus rhoncus quis in nisl. Fusc
e in velit varius, posuere risus et, cursus augue. Duis el
eifend aliquam ante, a aliquet ex tincidunt in. ",
"Vivamus venenatis egestas eros ut tempus. Vivamus id
est nisi. Aliquam molestie erat et sollicitudin venenatis.
In ac lacus at velit scelerisque mattis. "
)
)
kable(text_tbl, "html") %>%
kable_styling(full_width = F) %>%
column_spec(1, bold = T, border_right = T) %>%
column_spec(2, width = "30em", background = "yellow")
```

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;"> Items </th>
   <th style="text-align:left;"> Features </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;font-weight: bold;border-right:1px solid;"> Item 1 </td>
   <td style="text-align:left;width: 30em; background-color: yellow;"> Lorem ipsum dolor sit amet, consectetur adipiscing el
it. Proin vehicula tempor ex. Morbi malesuada sagittis tur
pis, at venenatis nisl luctus a. </td>
  </tr>
<tr>
<td style="text-align:left;font-weight: bold;border-right:1px solid;"> Item 2 </td>
   <td style="text-align:left;width: 30em; background-color: yellow;"> In eu urna at magna luctus rhoncus quis in nisl. Fusc
e in velit varius, posuere risus et, cursus augue. Duis el
eifend aliquam ante, a aliquet ex tincidunt in. </td>
  </tr>
<tr>
<td style="text-align:left;font-weight: bold;border-right:1px solid;"> Item 3 </td>
   <td style="text-align:left;width: 30em; background-color: yellow;"> Vivamus venenatis egestas eros ut tempus. Vivamus id
est nisi. Aliquam molestie erat et sollicitudin venenatis.
In ac lacus at velit scelerisque mattis. </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling("striped", full_width = F) %>%
column_spec(5:7, bold = T) %>%
row_spec(3:5, bold = T, color = "white", background = "#
D7261E")
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;font-weight: bold;"> 110 </td>
   <td style="text-align:right;font-weight: bold;"> 3.90 </td>
   <td style="text-align:right;font-weight: bold;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;font-weight: bold;"> 110 </td>
   <td style="text-align:right;font-weight: bold;"> 3.90 </td>
   <td style="text-align:right;font-weight: bold;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;font-weight: bold;color: white;background-color: #
D7261E;"> Datsun 710 </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 22.8 </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 4 </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 108 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 93 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 3.85 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;font-weight: bold;color: white;background-color: #
D7261E;"> Hornet 4 Drive </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 21.4 </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 6 </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 258 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 110 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 3.08 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;font-weight: bold;color: white;background-color: #
D7261E;"> Hornet Sportabout </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 18.7 </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 8 </td>
   <td style="text-align:right;font-weight: bold;color: white;background-color: #
D7261E;"> 360 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 175 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 3.15 </td>
   <td style="text-align:right;font-weight: bold;font-weight: bold;color: white;background-color: #
D7261E;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, format = "html") %>%
kable_styling("striped", full_width = F) %>%
row_spec(0, angle = -45)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;-webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg);">   </th>
   <th style="text-align:right;-webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg);"> mpg </th>
   <th style="text-align:right;-webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg);"> cyl </th>
   <th style="text-align:right;-webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg);"> disp </th>
   <th style="text-align:right;-webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg);"> hp </th>
   <th style="text-align:right;-webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg);"> drat </th>
   <th style="text-align:right;-webkit-transform: rotate(-45deg); -moz-transform: rotate(-45deg); -ms-transform: rotate(-45deg); -o-transform: rotate(-45deg); transform: rotate(-45deg);"> wt </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
mtcars[1:10, 1:2] %>%
mutate(
car = row.names(.),
# You don't need format = "html" if you have ever defined options(knitr.table.format)

mpg = cell_spec(mpg, "html", color = ifelse(mpg > 20,
"red", "blue")),
cyl = cell_spec(cyl, "html", color = "white", align =
"c", angle = 45,
background = factor(cyl, c(4, 6, 8),
c("#666666", "#999
999", "#BBBBBB")))
) %>%
select(car, mpg, cyl) %>%
kable("html", escape = F) %>%
kable_styling("striped", full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:left;"> car </th>
   <th style="text-align:left;"> mpg </th>
   <th style="text-align:left;"> cyl </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:left;"> <span style="color: red;">21</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #999
999;text-align: c;">6</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:left;"> <span style="color: red;">21</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #999
999;text-align: c;">6</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:left;"> <span style="color: red;">22.8</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #666666;text-align: c;">4</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:left;"> <span style="color: red;">21.4</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #999
999;text-align: c;">6</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:left;"> <span style="color: blue;">18.7</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #BBBBBB;text-align: c;">8</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Valiant </td>
   <td style="text-align:left;"> Valiant </td>
   <td style="text-align:left;"> <span style="color: blue;">18.1</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #999
999;text-align: c;">6</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Duster 360 </td>
   <td style="text-align:left;"> Duster 360 </td>
   <td style="text-align:left;"> <span style="color: blue;">14.3</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #BBBBBB;text-align: c;">8</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 240D </td>
   <td style="text-align:left;"> Merc 240D </td>
   <td style="text-align:left;"> <span style="color: red;">24.4</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #666666;text-align: c;">4</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 230 </td>
   <td style="text-align:left;"> Merc 230 </td>
   <td style="text-align:left;"> <span style="color: red;">22.8</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #666666;text-align: c;">4</span></span> </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 280 </td>
   <td style="text-align:left;"> Merc 280 </td>
   <td style="text-align:left;"> <span style="color: blue;">19.2</span> </td>
   <td style="text-align:left;"> <span style="-webkit-transform: rotate(45deg); -moz-transform: rotate(45deg); -ms-transform: rotate(45deg); -o-transform: rotate(45deg); transform: rotate(45deg); display: inline-block; "><span style="color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: #999
999;text-align: c;">6</span></span> </td>
  </tr>
</tbody>
</table>

```r
iris[1:10, ] %>%
mutate_if(is.numeric, function(x) {
cell_spec(x, "html", bold = T, color = spec_color(x, end = 0.9),
font_size = spec_font_size(x))
}) %>%
mutate(Species = cell_spec(
Species, "html", color = "white", bold = T,
background = spec_color(1:10, end = 0.9, option = "A",
direction = -1)
)) %>%
kable("html", escape = F, align = "c") %>%
kable_styling("striped", full_width = F)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:center;"> Sepal.Length </th>
   <th style="text-align:center;"> Sepal.Width </th>
   <th style="text-align:center;"> Petal.Length </th>
   <th style="text-align:center;"> Petal.Width </th>
   <th style="text-align:center;"> Species </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(40, 174, 128, 1);font-size: 14px;">5.1</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(31, 154, 138, 1);font-size: 13px;">3.5</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(62, 75, 138, 1);font-size: 10px;">1.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(53, 96, 141, 1);font-size: 11px;">0.2</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(254, 206, 145, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(37, 131, 142, 1);font-size: 12px;">4.9</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(72, 34, 116, 1);font-size: 9px;">3</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(62, 75, 138, 1);font-size: 10px;">1.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(53, 96, 141, 1);font-size: 11px;">0.2</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(254, 160, 109, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(57, 87, 140, 1);font-size: 10px;">4.7</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(56, 88, 140, 1);font-size: 10px;">3.2</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(68, 1, 84, 1);font-size: 8px;">1.3</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(53, 96, 141, 1);font-size: 11px;">0.2</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(246, 110, 92, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(67, 62, 133, 1);font-size: 10px;">4.6</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(67, 62, 133, 1);font-size: 10px;">3.1</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(37, 131, 142, 1);font-size: 12px;">1.5</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(53, 96, 141, 1);font-size: 11px;">0.2</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(222, 73, 104, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(31, 154, 138, 1);font-size: 13px;">5</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(41, 175, 127, 1);font-size: 14px;">3.6</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(62, 75, 138, 1);font-size: 10px;">1.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(53, 96, 141, 1);font-size: 11px;">0.2</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(183, 55, 121, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(187, 223, 39, 1);font-size: 16px;">5.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(187, 223, 39, 1);font-size: 16px;">3.9</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(187, 223, 39, 1);font-size: 16px;">1.7</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(187, 223, 39, 1);font-size: 16px;">0.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(140, 41, 129, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(67, 62, 133, 1);font-size: 10px;">4.6</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(37, 131, 142, 1);font-size: 12px;">3.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(62, 75, 138, 1);font-size: 10px;">1.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(34, 168, 132, 1);font-size: 13px;">0.3</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(100, 26, 128, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(31, 154, 138, 1);font-size: 13px;">5</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(37, 131, 142, 1);font-size: 12px;">3.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(37, 131, 142, 1);font-size: 12px;">1.5</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(53, 96, 141, 1);font-size: 11px;">0.2</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(60, 15, 112, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(68, 1, 84, 1);font-size: 8px;">4.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(68, 1, 84, 1);font-size: 8px;">2.9</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(62, 75, 138, 1);font-size: 10px;">1.4</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(53, 96, 141, 1);font-size: 11px;">0.2</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(20, 14, 54, 1);">setosa</span> </td>
  </tr>
<tr>
<td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(37, 131, 142, 1);font-size: 12px;">4.9</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(67, 62, 133, 1);font-size: 10px;">3.1</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(37, 131, 142, 1);font-size: 12px;">1.5</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: rgba(68, 1, 84, 1);font-size: 8px;">0.1</span> </td>
   <td style="text-align:center;"> <span style=" font-weight: bold;color: white;border-radius: 4px; padding-right: 4px; padding-left: 4px; background-color: rgba(0, 0, 4, 1);">setosa</span> </td>
  </tr>
</tbody>
</table>

```r
sometext <- strsplit(paste0(
"You can even try to make some crazy things like this paragraph. ",
"It may seem like a useless feature right now but it's so cool ",
"and nobody can resist. ;)"
), " ")[[1]]
text_formatted <- paste(
text_spec(sometext, "html", color = spec_color(1:length(
sometext), end = 0.9),
font_size = spec_font_size(1:length(sometext),
begin = 5, end = 20)),
collapse = " ")

#To display the text, type `r text_formatted` outside of the chunk

popover_dt <- data.frame(
position = c("top", "bottom", "right", "left"),
stringsAsFactors = FALSE
)
popover_dt$`Hover over these items` <- cell_spec(
paste("Message on", popover_dt$position), # Cell texts
popover = spec_popover(
content = popover_dt$position,
title = NULL, # title will add a Title Panel on top
position = popover_dt$position
))
kable(popover_dt, "html", escape = FALSE) %>%
kable_styling("striped", full_width = FALSE)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;"> position </th>
   <th style="text-align:left;"> Hover over these items </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> top </td>
   <td style="text-align:left;"> <span style="" data-toggle="popover" data-trigger="hover" data-placement="top" data-content="top">Message on top</span> </td>
  </tr>
<tr>
<td style="text-align:left;"> bottom </td>
   <td style="text-align:left;"> <span style="" data-toggle="popover" data-trigger="hover" data-placement="bottom" data-content="bottom">Message on bottom</span> </td>
  </tr>
<tr>
<td style="text-align:left;"> right </td>
   <td style="text-align:left;"> <span style="" data-toggle="popover" data-trigger="hover" data-placement="right" data-content="right">Message on right</span> </td>
  </tr>
<tr>
<td style="text-align:left;"> left </td>
   <td style="text-align:left;"> <span style="" data-toggle="popover" data-trigger="hover" data-placement="left" data-content="left">Message on left</span> </td>
  </tr>
</tbody>
</table>

```r
popover_dt <- data.frame(
position = c("top", "bottom", "right", "left"),
stringsAsFactors = FALSE
)
popover_dt$`Hover over these items` <- cell_spec(
paste("Message on", popover_dt$position), # Cell texts
popover = spec_popover(
content = popover_dt$position,
title = NULL, # title will add a Title Panel on top
position = popover_dt$position
))
kable(popover_dt, "html", escape = FALSE) %>%
kable_styling("striped", full_width = FALSE)
```

<table class="table table-striped" style="width: auto !important; margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;"> position </th>
   <th style="text-align:left;"> Hover over these items </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> top </td>
   <td style="text-align:left;"> <span style="" data-toggle="popover" data-trigger="hover" data-placement="top" data-content="top">Message on top</span> </td>
  </tr>
<tr>
<td style="text-align:left;"> bottom </td>
   <td style="text-align:left;"> <span style="" data-toggle="popover" data-trigger="hover" data-placement="bottom" data-content="bottom">Message on bottom</span> </td>
  </tr>
<tr>
<td style="text-align:left;"> right </td>
   <td style="text-align:left;"> <span style="" data-toggle="popover" data-trigger="hover" data-placement="right" data-content="right">Message on right</span> </td>
  </tr>
<tr>
<td style="text-align:left;"> left </td>
   <td style="text-align:left;"> <span style="" data-toggle="popover" data-trigger="hover" data-placement="left" data-content="left">Message on left</span> </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling("striped") %>%
add_header_above(c(" " = 1, "Group 1" = 2, "Group 2" = 2, "Group 3" = 2))
```

<table class="table table-striped" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="border-bottom:hidden" colspan="1"></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="2"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 1</div></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="2"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 2</div></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="2"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 3</div></th>
</tr>
<tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(dt, "html") %>%
kable_styling(c("striped", "bordered")) %>%
add_header_above(c(" ", "Group 1" = 2, "Group 2" = 2, "Group 3" = 2)) %>%
add_header_above(c(" ", "Group 4" = 4, "Group 5" = 2)) %>%
add_header_above(c(" ", "Group 6" = 6))
```

<table class="table table-striped table-bordered" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="border-bottom:hidden" colspan="1"></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="6"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 6</div></th>
</tr>
<tr>
<th style="border-bottom:hidden" colspan="1"></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="4"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 4</div></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="2"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 5</div></th>
</tr>
<tr>
<th style="border-bottom:hidden" colspan="1"></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="2"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 1</div></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="2"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 2</div></th>
<th style="text-align:center; border-bottom:hidden; padding-bottom:0; padding-left:3px;padding-right:3px;" colspan="2"><div style="border-bottom: 1px solid #ddd; padding-bottom: 5px;">Group 3</div></th>
</tr>
<tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
  </tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
  </tr>
</tbody>
</table>

```r
kable(cbind(mtcars, mtcars), "html") %>%
kable_styling() %>%
scroll_box(width = "900px", height = "600px")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-y: scroll; height:600px; overflow-x: scroll; width:900px; "><table class="table" style="margin-left: auto; margin-right: auto;">
<thead><tr>
<th style="text-align:left;">   </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
   <th style="text-align:right;"> qsec </th>
   <th style="text-align:right;"> vs </th>
   <th style="text-align:right;"> am </th>
   <th style="text-align:right;"> gear </th>
   <th style="text-align:right;"> carb </th>
   <th style="text-align:right;"> mpg </th>
   <th style="text-align:right;"> cyl </th>
   <th style="text-align:right;"> disp </th>
   <th style="text-align:right;"> hp </th>
   <th style="text-align:right;"> drat </th>
   <th style="text-align:right;"> wt </th>
   <th style="text-align:right;"> qsec </th>
   <th style="text-align:right;"> vs </th>
   <th style="text-align:right;"> am </th>
   <th style="text-align:right;"> gear </th>
   <th style="text-align:right;"> carb </th>
  </tr></thead>
<tbody>
<tr>
<td style="text-align:left;"> Mazda RX4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160.0 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
   <td style="text-align:right;"> 16.46 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160.0 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.620 </td>
   <td style="text-align:right;"> 16.46 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Mazda RX4 Wag </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160.0 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 21.0 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 160.0 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.90 </td>
   <td style="text-align:right;"> 2.875 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Datsun 710 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108.0 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
   <td style="text-align:right;"> 18.61 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 108.0 </td>
   <td style="text-align:right;"> 93 </td>
   <td style="text-align:right;"> 3.85 </td>
   <td style="text-align:right;"> 2.320 </td>
   <td style="text-align:right;"> 18.61 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet 4 Drive </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258.0 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
   <td style="text-align:right;"> 19.44 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 258.0 </td>
   <td style="text-align:right;"> 110 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.215 </td>
   <td style="text-align:right;"> 19.44 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Hornet Sportabout </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360.0 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 18.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360.0 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 17.02 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> Valiant </td>
   <td style="text-align:right;"> 18.1 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 225.0 </td>
   <td style="text-align:right;"> 105 </td>
   <td style="text-align:right;"> 2.76 </td>
   <td style="text-align:right;"> 3.460 </td>
   <td style="text-align:right;"> 20.22 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 18.1 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 225.0 </td>
   <td style="text-align:right;"> 105 </td>
   <td style="text-align:right;"> 2.76 </td>
   <td style="text-align:right;"> 3.460 </td>
   <td style="text-align:right;"> 20.22 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Duster 360 </td>
   <td style="text-align:right;"> 14.3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360.0 </td>
   <td style="text-align:right;"> 245 </td>
   <td style="text-align:right;"> 3.21 </td>
   <td style="text-align:right;"> 3.570 </td>
   <td style="text-align:right;"> 15.84 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 14.3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 360.0 </td>
   <td style="text-align:right;"> 245 </td>
   <td style="text-align:right;"> 3.21 </td>
   <td style="text-align:right;"> 3.570 </td>
   <td style="text-align:right;"> 15.84 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 240D </td>
   <td style="text-align:right;"> 24.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 146.7 </td>
   <td style="text-align:right;"> 62 </td>
   <td style="text-align:right;"> 3.69 </td>
   <td style="text-align:right;"> 3.190 </td>
   <td style="text-align:right;"> 20.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 24.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 146.7 </td>
   <td style="text-align:right;"> 62 </td>
   <td style="text-align:right;"> 3.69 </td>
   <td style="text-align:right;"> 3.190 </td>
   <td style="text-align:right;"> 20.00 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 230 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 140.8 </td>
   <td style="text-align:right;"> 95 </td>
   <td style="text-align:right;"> 3.92 </td>
   <td style="text-align:right;"> 3.150 </td>
   <td style="text-align:right;"> 22.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 22.8 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 140.8 </td>
   <td style="text-align:right;"> 95 </td>
   <td style="text-align:right;"> 3.92 </td>
   <td style="text-align:right;"> 3.150 </td>
   <td style="text-align:right;"> 22.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 280 </td>
   <td style="text-align:right;"> 19.2 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 167.6 </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 3.92 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 18.30 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 19.2 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 167.6 </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 3.92 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 18.30 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 280C </td>
   <td style="text-align:right;"> 17.8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 167.6 </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 3.92 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 18.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 17.8 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 167.6 </td>
   <td style="text-align:right;"> 123 </td>
   <td style="text-align:right;"> 3.92 </td>
   <td style="text-align:right;"> 3.440 </td>
   <td style="text-align:right;"> 18.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 450SE </td>
   <td style="text-align:right;"> 16.4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 275.8 </td>
   <td style="text-align:right;"> 180 </td>
   <td style="text-align:right;"> 3.07 </td>
   <td style="text-align:right;"> 4.070 </td>
   <td style="text-align:right;"> 17.40 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 16.4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 275.8 </td>
   <td style="text-align:right;"> 180 </td>
   <td style="text-align:right;"> 3.07 </td>
   <td style="text-align:right;"> 4.070 </td>
   <td style="text-align:right;"> 17.40 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 450SL </td>
   <td style="text-align:right;"> 17.3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 275.8 </td>
   <td style="text-align:right;"> 180 </td>
   <td style="text-align:right;"> 3.07 </td>
   <td style="text-align:right;"> 3.730 </td>
   <td style="text-align:right;"> 17.60 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 17.3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 275.8 </td>
   <td style="text-align:right;"> 180 </td>
   <td style="text-align:right;"> 3.07 </td>
   <td style="text-align:right;"> 3.730 </td>
   <td style="text-align:right;"> 17.60 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
<tr>
<td style="text-align:left;"> Merc 450SLC </td>
   <td style="text-align:right;"> 15.2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 275.8 </td>
   <td style="text-align:right;"> 180 </td>
   <td style="text-align:right;"> 3.07 </td>
   <td style="text-align:right;"> 3.780 </td>
   <td style="text-align:right;"> 18.00 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 15.2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 275.8 </td>
   <td style="text-align:right;"> 180 </td>
   <td style="text-align:right;"> 3.07 </td>
   <td style="text-align:right;"> 3.780 </td>
   <td style="text-align:right;"> 18.00 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
<tr>
<td style="text-align:left;"> Cadillac Fleetwood </td>
   <td style="text-align:right;"> 10.4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 472.0 </td>
   <td style="text-align:right;"> 205 </td>
   <td style="text-align:right;"> 2.93 </td>
   <td style="text-align:right;"> 5.250 </td>
   <td style="text-align:right;"> 17.98 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 10.4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 472.0 </td>
   <td style="text-align:right;"> 205 </td>
   <td style="text-align:right;"> 2.93 </td>
   <td style="text-align:right;"> 5.250 </td>
   <td style="text-align:right;"> 17.98 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Lincoln Continental </td>
   <td style="text-align:right;"> 10.4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 460.0 </td>
   <td style="text-align:right;"> 215 </td>
   <td style="text-align:right;"> 3.00 </td>
   <td style="text-align:right;"> 5.424 </td>
   <td style="text-align:right;"> 17.82 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 10.4 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 460.0 </td>
   <td style="text-align:right;"> 215 </td>
   <td style="text-align:right;"> 3.00 </td>
   <td style="text-align:right;"> 5.424 </td>
   <td style="text-align:right;"> 17.82 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Chrysler Imperial </td>
   <td style="text-align:right;"> 14.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 440.0 </td>
   <td style="text-align:right;"> 230 </td>
   <td style="text-align:right;"> 3.23 </td>
   <td style="text-align:right;"> 5.345 </td>
   <td style="text-align:right;"> 17.42 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 14.7 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 440.0 </td>
   <td style="text-align:right;"> 230 </td>
   <td style="text-align:right;"> 3.23 </td>
   <td style="text-align:right;"> 5.345 </td>
   <td style="text-align:right;"> 17.42 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Fiat 128 </td>
   <td style="text-align:right;"> 32.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 78.7 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 4.08 </td>
   <td style="text-align:right;"> 2.200 </td>
   <td style="text-align:right;"> 19.47 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 32.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 78.7 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 4.08 </td>
   <td style="text-align:right;"> 2.200 </td>
   <td style="text-align:right;"> 19.47 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Honda Civic </td>
   <td style="text-align:right;"> 30.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 75.7 </td>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:right;"> 4.93 </td>
   <td style="text-align:right;"> 1.615 </td>
   <td style="text-align:right;"> 18.52 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 30.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 75.7 </td>
   <td style="text-align:right;"> 52 </td>
   <td style="text-align:right;"> 4.93 </td>
   <td style="text-align:right;"> 1.615 </td>
   <td style="text-align:right;"> 18.52 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> Toyota Corolla </td>
   <td style="text-align:right;"> 33.9 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 71.1 </td>
   <td style="text-align:right;"> 65 </td>
   <td style="text-align:right;"> 4.22 </td>
   <td style="text-align:right;"> 1.835 </td>
   <td style="text-align:right;"> 19.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 33.9 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 71.1 </td>
   <td style="text-align:right;"> 65 </td>
   <td style="text-align:right;"> 4.22 </td>
   <td style="text-align:right;"> 1.835 </td>
   <td style="text-align:right;"> 19.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Toyota Corona </td>
   <td style="text-align:right;"> 21.5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 120.1 </td>
   <td style="text-align:right;"> 97 </td>
   <td style="text-align:right;"> 3.70 </td>
   <td style="text-align:right;"> 2.465 </td>
   <td style="text-align:right;"> 20.01 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 21.5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 120.1 </td>
   <td style="text-align:right;"> 97 </td>
   <td style="text-align:right;"> 3.70 </td>
   <td style="text-align:right;"> 2.465 </td>
   <td style="text-align:right;"> 20.01 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Dodge Challenger </td>
   <td style="text-align:right;"> 15.5 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 318.0 </td>
   <td style="text-align:right;"> 150 </td>
   <td style="text-align:right;"> 2.76 </td>
   <td style="text-align:right;"> 3.520 </td>
   <td style="text-align:right;"> 16.87 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 15.5 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 318.0 </td>
   <td style="text-align:right;"> 150 </td>
   <td style="text-align:right;"> 2.76 </td>
   <td style="text-align:right;"> 3.520 </td>
   <td style="text-align:right;"> 16.87 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> AMC Javelin </td>
   <td style="text-align:right;"> 15.2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 304.0 </td>
   <td style="text-align:right;"> 150 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.435 </td>
   <td style="text-align:right;"> 17.30 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 15.2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 304.0 </td>
   <td style="text-align:right;"> 150 </td>
   <td style="text-align:right;"> 3.15 </td>
   <td style="text-align:right;"> 3.435 </td>
   <td style="text-align:right;"> 17.30 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> Camaro Z28 </td>
   <td style="text-align:right;"> 13.3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 350.0 </td>
   <td style="text-align:right;"> 245 </td>
   <td style="text-align:right;"> 3.73 </td>
   <td style="text-align:right;"> 3.840 </td>
   <td style="text-align:right;"> 15.41 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 13.3 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 350.0 </td>
   <td style="text-align:right;"> 245 </td>
   <td style="text-align:right;"> 3.73 </td>
   <td style="text-align:right;"> 3.840 </td>
   <td style="text-align:right;"> 15.41 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Pontiac Firebird </td>
   <td style="text-align:right;"> 19.2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 400.0 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.845 </td>
   <td style="text-align:right;"> 17.05 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 19.2 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 400.0 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.08 </td>
   <td style="text-align:right;"> 3.845 </td>
   <td style="text-align:right;"> 17.05 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> Fiat X1-9 </td>
   <td style="text-align:right;"> 27.3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 79.0 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 4.08 </td>
   <td style="text-align:right;"> 1.935 </td>
   <td style="text-align:right;"> 18.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 27.3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 79.0 </td>
   <td style="text-align:right;"> 66 </td>
   <td style="text-align:right;"> 4.08 </td>
   <td style="text-align:right;"> 1.935 </td>
   <td style="text-align:right;"> 18.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
<tr>
<td style="text-align:left;"> Porsche 914-2 </td>
   <td style="text-align:right;"> 26.0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 120.3 </td>
   <td style="text-align:right;"> 91 </td>
   <td style="text-align:right;"> 4.43 </td>
   <td style="text-align:right;"> 2.140 </td>
   <td style="text-align:right;"> 16.70 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 26.0 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 120.3 </td>
   <td style="text-align:right;"> 91 </td>
   <td style="text-align:right;"> 4.43 </td>
   <td style="text-align:right;"> 2.140 </td>
   <td style="text-align:right;"> 16.70 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> Lotus Europa </td>
   <td style="text-align:right;"> 30.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 95.1 </td>
   <td style="text-align:right;"> 113 </td>
   <td style="text-align:right;"> 3.77 </td>
   <td style="text-align:right;"> 1.513 </td>
   <td style="text-align:right;"> 16.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 30.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 95.1 </td>
   <td style="text-align:right;"> 113 </td>
   <td style="text-align:right;"> 3.77 </td>
   <td style="text-align:right;"> 1.513 </td>
   <td style="text-align:right;"> 16.90 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
<tr>
<td style="text-align:left;"> Ford Pantera L </td>
   <td style="text-align:right;"> 15.8 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 351.0 </td>
   <td style="text-align:right;"> 264 </td>
   <td style="text-align:right;"> 4.22 </td>
   <td style="text-align:right;"> 3.170 </td>
   <td style="text-align:right;"> 14.50 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 15.8 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 351.0 </td>
   <td style="text-align:right;"> 264 </td>
   <td style="text-align:right;"> 4.22 </td>
   <td style="text-align:right;"> 3.170 </td>
   <td style="text-align:right;"> 14.50 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
  </tr>
<tr>
<td style="text-align:left;"> Ferrari Dino </td>
   <td style="text-align:right;"> 19.7 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 145.0 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.62 </td>
   <td style="text-align:right;"> 2.770 </td>
   <td style="text-align:right;"> 15.50 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 19.7 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 145.0 </td>
   <td style="text-align:right;"> 175 </td>
   <td style="text-align:right;"> 3.62 </td>
   <td style="text-align:right;"> 2.770 </td>
   <td style="text-align:right;"> 15.50 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 6 </td>
  </tr>
<tr>
<td style="text-align:left;"> Maserati Bora </td>
   <td style="text-align:right;"> 15.0 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 301.0 </td>
   <td style="text-align:right;"> 335 </td>
   <td style="text-align:right;"> 3.54 </td>
   <td style="text-align:right;"> 3.570 </td>
   <td style="text-align:right;"> 14.60 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 15.0 </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 301.0 </td>
   <td style="text-align:right;"> 335 </td>
   <td style="text-align:right;"> 3.54 </td>
   <td style="text-align:right;"> 3.570 </td>
   <td style="text-align:right;"> 14.60 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
<tr>
<td style="text-align:left;"> Volvo 142E </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 121.0 </td>
   <td style="text-align:right;"> 109 </td>
   <td style="text-align:right;"> 4.11 </td>
   <td style="text-align:right;"> 2.780 </td>
   <td style="text-align:right;"> 18.60 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 21.4 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 121.0 </td>
   <td style="text-align:right;"> 109 </td>
   <td style="text-align:right;"> 4.11 </td>
   <td style="text-align:right;"> 2.780 </td>
   <td style="text-align:right;"> 18.60 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
</tbody>
</table></div>

<span style="color: rgba(68, 1, 84, 1);font-size: 5px;" >You</span> <span style="color: rgba(71, 13, 96, 1);font-size: 6px;" >can</span> <span style="color: rgba(72, 24, 106, 1);font-size: 6px;" >even</span> <span style="color: rgba(72, 34, 116, 1);font-size: 7px;" >try</span> <span style="color: rgba(71, 45, 122, 1);font-size: 7px;" >to</span> <span style="color: rgba(69, 54, 129, 1);font-size: 8px;" >make</span> <span style="color: rgba(66, 64, 134, 1);font-size: 8px;" >some</span> <span style="color: rgba(62, 73, 137, 1);font-size: 9px;" >crazy</span> <span style="color: rgba(59, 81, 139, 1);font-size: 9px;" >things</span> <span style="color: rgba(55, 90, 140, 1);font-size: 10px;" >like</span> <span style="color: rgba(51, 98, 141, 1);font-size: 10px;" >this</span> <span style="color: rgba(48, 106, 142, 1);font-size: 11px;" >paragraph.</span> <span style="color: rgba(44, 113, 142, 1);font-size: 11px;" >It</span> <span style="color: rgba(41, 121, 142, 1);font-size: 12px;" >may</span> <span style="color: rgba(38, 129, 142, 1);font-size: 12px;" >seem</span> <span style="color: rgba(35, 136, 142, 1);font-size: 13px;" >like</span> <span style="color: rgba(33, 144, 141, 1);font-size: 13px;" >a</span> <span style="color: rgba(31, 150, 139, 1);font-size: 14px;" >useless</span> <span style="color: rgba(31, 158, 137, 1);font-size: 14px;" >feature</span> <span style="color: rgba(33, 165, 133, 1);font-size: 15px;" >right</span> <span style="color: rgba(38, 173, 129, 1);font-size: 15px;" >now</span> <span style="color: rgba(48, 180, 124, 1);font-size: 16px;" >but</span> <span style="color: rgba(59, 187, 117, 1);font-size: 16px;" >it's</span> <span style="color: rgba(74, 193, 109, 1);font-size: 17px;" >so</span> <span style="color: rgba(90, 200, 100, 1);font-size: 17px;" >cool</span> <span style="color: rgba(108, 205, 90, 1);font-size: 18px;" >and</span> <span style="color: rgba(127, 211, 78, 1);font-size: 18px;" >nobody</span> <span style="color: rgba(145, 215, 66, 1);font-size: 19px;" >can</span> <span style="color: rgba(166, 219, 53, 1);font-size: 19px;" >resist.</span> <span style="color: rgba(187, 223, 39, 1);font-size: 20px;" >;)</span>

# Create a new data.frame with columns rearranged with the CLEAN data


```r
procrastinateClean <- select(procrastinate, RowID,
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

## Write csv files for client


```r
# Write CSV in R
# write.csv(procrastinateClean, file = "Test.csv")
# write.csv(HDIMerged, file = "merged.csv", row.names=FALSE )
```
