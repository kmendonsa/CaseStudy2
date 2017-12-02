# PROCRASTINATION
Kevin Mendonsa & Ruhaab Markas  
November 26, 2017  



## PROCRASTINATION

Description
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

# Set the working directory for the Data


```r
BaseDir <- "C:\\Users\\kevinm\\Documents\\SMU\\MSDS6306_Tibbett\\CaseStudy2\\"

# set working directory
  setwd(BaseDir)
```

# Load the data from the csv files


```r
procrastinate_raw <- read.csv("Procrastination.csv", 
                                                    na.strings = "NA", 
                                                    blank.lines.skip = TRUE,
                                                    sep = ",",
                                                    strip.white = TRUE)
```
  
# Number of Rows/Observations and Columns/Variables in the dataset

```r
dim(procrastinate_raw)
```

```
## [1] 4264   61
```
  
# Prepare data for cleansing and transformaiton 

```r
# Add a uniqueID to each row - we may need it later
  procrastinate_raw <- rowid_to_column(procrastinate_raw, "RowID")

# Create a new data frame from the raw data for cleansing but retain the original dataset for reference purposes
  procrastinate <- procrastinate_raw
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
  procrastinate$Occupation <- str_trim(procrastinate$Occupation) # Trim whitespace on left and right of value
  
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


# Clean other fields


```r
# Replace missing values in "Gender" with an explicit "*Missing*"
procrastinate$Gender <- gsub("^$", "*Missing*", procrastinate$Gender)

# Remove the word "Kids" and Format values to capitalize first letter for fields "Kids", "SelfProcrast" & "OtherProcrast"
procrastinate$Kids <- gsub(" Kids","", # Remove the word "Kids"
                            gsub("^$","*Missing*",procrastinate$Kids ))# Replace blanks with "*Missing*"


# Clean up "WrkStatus" where value is 0, rename blanks to "*Missing*" ands capitalize first letter
procrastinate$WrkStatus <- gsub("0","*Missing*", # Replace "0" with *Missing*
                                gsub("^$","*Missing*", procrastinate$WrkStatus)) # Replace "blanks" with *Missing*
                                 

# Clean up "YearsInPosition" and rename blanks to "*Missing*"
procrastinate$YearsInPos <- gsub("999",NA, # Replace 999 to "*Missing*"
                            gsub("^$" ,NA, 
                           round(as.integer(procrastinate$YearsInPos), digits = 0 )# #Convert to integer and round to the nearest integer
                                )
                                )

# Clean up "Marital Status"
procrastinate$MaritalStat <- gsub("0","*Missing*", # Replace 0 to NA
                                 gsub("^$" , "*Missing*", procrastinate$MaritalStat))
# Clean up "CommSize"
procrastinate$CommSize <- gsub("^$" , "*Missing*", procrastinate$CommSize)

procrastinate$CommSize <- plyr::revalue(procrastinate$CommSize,
                                        c("0" = "*Missing*", 
                                          "8" = "*Missing*"))

# Clean up "Country"
procrastinate$Country <- gsub("0","*Missing*", # Replace 0 to NA
                                  gsub("^$" , "*Missing*", procrastinate$Country))

# Clean up "Sons" set Male=1 and Female=2 
procrastinate$Sons <- gsub("Female"  , "2", 
                      gsub("Male", "1", 
                                procrastinate$Sons))

# Convert fields to integer as required
procrastinate$Sons <- as.integer(procrastinate$Sons)

# Clean up "Self Procrastinator" field by setting blanks to an explicit "*Missing*" 
procrastinate$SelfProcrast <- gsub("^$" , "*Missing*", procrastinate$SelfProcrast)

# Clean up the field "Others say you are a procrastinator" by replacing 0s, 4s & "blanks" with "*Missing*" 
procrastinate$OthrProcrast <- gsub("^$" , "*Missing*", procrastinate$OthrProcrast)
procrastinate$OthrProcrast <- plyr::revalue(procrastinate$OthrProcrast,
                                        c("0" = "*Missing*", 
                                          "4" = "*Missing*"))

# Change to "Title" case
procrastinate$Kids           <- str_to_title(procrastinate$Kids, locale = "en") # Replace blanks with "*Missing*"
procrastinate$SelfProcrast   <- str_to_title(procrastinate$SelfProcrast, locale = "en") # Change to "Title" case
procrastinate$OthrProcrast   <- str_to_title(procrastinate$OthrProcrast, locale = "en") # Change to "Title" case
procrastinate$OccupatnAlt    <- str_to_upper(procrastinate$OccupatnAlt, locale = "en") # Change to UPPER case
procrastinate$WrkStatus      <- str_to_title(procrastinate$WrkStatus, locale = "en")
```


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

