### R - environment

sessionInfo()

### Libraries required
library(tidyr)

library(sqldf)

library(dplyr)

library(plyr)

library(tidyverse)

library(stringr)

library(qwraps2)

library(ggplot2)

library(RColorBrewer)

library(kableExtra)

library(knitr)

# define the markup language we are working in.
# options(qwraps2_markup = "latex") is also supported.
options(qwraps2_markup = "markdown")
options(knitr.table.format = "html")

# Set the working directory for the Data
  BaseDir <- "C:\\Users\\kevinm\\Documents\\SMU\\MSDS6306_Tibbett\\CaseStudy2\\"

# set working directory
  setwd(BaseDir)

# Load the data from the csv files and from the web
  procrastinate_raw <- read.csv("Procrastination.csv", 
                          na.strings = "NA", 
                          blank.lines.skip = TRUE,
                          sep = ",",
                          strip.white = TRUE)
  
# Assign the url to scrape the data from
  HDI_url <- "https://en.wikipedia.org/wiki/List_of_countries_by_Human_Development_Index#Complete_list_of_countries"
  
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
        VHigh_HDI_df <- sqldf("select 'Very High' as Category, 
                                                X3 as Country, 
                                                    X4 as HDI
                              from VHigh_HDI_df
                              Where VHigh_HDI_df.X3 
                              not in ('Rank', 'Country','Change in rank from previous year[1]') 
                              ")
        
        High_HDI_df <- sqldf("select 'High' as Category, 
                                          X3 as Country, 
                                              X4 as HDI
                              from High_HDI_df
                              Where High_HDI_df.X3 
                              not in ('Rank', 'Country','Change in rank from previous year[1]') 
                              ")
        
        Med_HDI_df <- sqldf("select 'Med' as Category, 
                                        X3 as Country, 
                                            X4 as HDI
                              from Med_HDI_df
                              Where Med_HDI_df.X3 
                              not in ('Rank', 'Country','Change in rank from previous year[1]') 
                            ")
        
        Low_HDI_df <- sqldf("select 'Low' as Category, 
                                        X3 as Country, 
                                            X4 as HDI
                              from Low_HDI_df
                              Where Low_HDI_df.X3 
                              not in ('Rank', 'Country','Change in rank from previous year[1]') 
                            ")
        
# Merge all the data frames into a single data frame
        HDI_raw <- rbind(VHigh_HDI_df,
                         High_HDI_df,
                         Med_HDI_df,
                         Low_HDI_df )
        
# Number of Rows/Observations and Columns/Variables in the dataset
  dim(procrastinate_raw)
  dim(HDI_raw)

# Add a uniqueID to each row - we may need it later
  procrastinate_raw <- rowid_to_column(procrastinate_raw, "RowID")

# Create a new data frame from the raw data for cleansing but retain the original dataset for reference purposes
  procrastinate <- procrastinate_raw
  webscrape     <- HDI_raw
  
# Rename the variables
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
  
# Add new columns for the mean of each survey mean by individual - DPMean, AIPMean, GPMean, SWLSMean
  procrastinate <-  transform(procrastinate,  DPMean = rowMeans(procrastinate[,15:19], na.rm = TRUE)) %>% 
                                  transform( AIPMean = rowMeans(procrastinate[,20:34], na.rm = TRUE)) %>%
                                  transform(  GPMean = rowMeans(procrastinate[,35:54], na.rm = TRUE)) %>%
                                  transform(SWLSMean = rowMeans(procrastinate[,55:59], na.rm = TRUE)) 
  
# Round all means to 2 digits to  
  procrastinate$DPMean   <- round(procrastinate$DPMean,   digits =2)
  procrastinate$AIPMean  <- round(procrastinate$AIPMean,  digits =2)
  procrastinate$GPMean   <- round(procrastinate$GPMean,   digits =2)
  procrastinate$SWLSMean <- round(procrastinate$SWLSMean, digits =2)
                       

# Remove whitepsace by trimming the right and left sides
  procrastinate$Occupation <- str_trim(procrastinate$Occupation) # Trim whitespace on left and right of value
  
# Clean up "Occupations"
# Replace all "blank" values with an explicit "*Missing*"
  procrastinate$OccupatnAlt <-gsub("^$","*Missing*",procrastinate$Occupation)
  
# Normalize the data and make it easier to group/categorize if necessary  
  procrastinate$OccupatnAlt <-revalue(procrastinate$OccupatnAlt ,
                                         c( "0" = "*Missing*", 
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

#  Rename values in the field "Edu" to meaningful names and load to a new column named "Alt_Education"
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

# Merge the webscrape and procrastinate data frames on country doing a left join on webscrape
# Let's trim all whitespace in the country field of the webscrape
HDI_raw$Country <- str_trim(HDI_raw$Country) # Trim whitespace on left and right of value
procrastinate$Country <- str_trim(procrastinate$Country) # Trim whitespace on left and right of value

# Rectify some name spellings in the countries between the web data and the procrastinate data
procrastinate$Country <- plyr::revalue(procrastinate$Country,
                                            c("Columbia" = "Colombia", 
                                              "Isreal"   = "Israel"))


# Merge the two data sets to a single data set
HDIMerged <- merge(procrastinate, HDI_raw, by = "Country", all.x = TRUE)

# ANALYSIS:
# Exclude all observations where the participant is under 18 years of age and 80 and over
# Removed the age group 80 and above - Provide reason
HDIMerged <- filter(HDIMerged, Age > 18) %>%
                filter(Age < 79 )

# Histogram for SWLSMean
qplot(HDIMerged$AIPMean,
      geom="histogram",
      binwidth = .25,  
      main = "Histogram of AIP Mean", 
      xlab = "SWLS Mean",  
      fill=I("blue"), 
      col=I("red"),
      xlim=c(0,5.5),
      alpha=I(.4))

# Histogram for GPMean
ggplot(data=HDIMerged, aes(x=HDIMerged$GPMean)) + 
  geom_histogram(binwidth = .25, 
                 col="red", 
                 fill="green", 
                 alpha = .2) + 
  labs(title="Histogram of SWLS Mean", x="SWLS Mean", y="Count") + 
  xlim(c(0,5)) + 
  ylim(c(0,550))

# Comment on the shape of the distributions

GenderFreq <- table(HDIMerged$Gender) %>%
  print()

WrkStatusFreq <- table(HDIMerged$WrkStatus)%>%
  print()
  
OccupationAltFreq <- table(HDIMerged$OccupatnAlt) %>%
  print()  

Country <- sqldf ("select Country, Count(Country) as Count
                    from HDIMerged 
                    Where Country<>'*Missing*'
                    Group by Country 
                    Order by Country") %>%
            print()

Matched <- sqldf ("select Count(1) as 'Matched'
                    from HDIMerged 
                    Where SelfProcrast=OthrProcrast
                    ")

                  dt <- mtcars[1:5, 1:6]
                  
                  kable(dt, "html")      
                  

ggplot(HDIMerged, aes(GPMean, fill=GPMean)) +
        geom_histogram(binwidth = .25) +
        xlab("SWLS Mean") + 
        ylab("Count") + 
        ggtitle("Histogram of SWLS Mean")+
        theme(plot.title = element_text(hjust = 0.5))+
        scale_fill_brewer(palette = "Blues")


# args(summary_table)
# ## function (.data, summaries) 
# ## NULL
# 
# our_summary1 <- 
#   list("Age" = 
#          list("min" = ~ min(Age),
#               "max" = ~ max(Age),
#               "mean (sd)" = ~ qwraps2::mean_sd(Age)),
#        "Income" = 
#          list("min" = ~ min(Income), 
#               "max" = ~ max(Income),
#               "mean (sd)" = ~ qwraps2::mean_sd(Income)),
#        "HDI" = 
#          list("min" = ~ min(HDI2016_2015), 
#               "max" = ~ max(wt),
#               "mean (sd)" = ~ qwraps2::mean_sd(wt)),
#        "DP Mean" = 
#          list("Three" = ~ qwraps2::n_perc0(gear == 3),
#               "Four"  = ~ qwraps2::n_perc0(gear == 4),
#               "Five"  = ~ qwraps2::n_perc0(gear == 5)),
#        "AIP Mean" = 
#          list("Three" = ~ qwraps2::n_perc0(gear == 3),
#               "Four"  = ~ qwraps2::n_perc0(gear == 4),
#               "Five"  = ~ qwraps2::n_perc0(gear == 5)),
#        "GP Mean" = 
#          list("Three" = ~ qwraps2::n_perc0(gear == 3),
#               "Four"  = ~ qwraps2::n_perc0(gear == 4),
#               "Five"  = ~ qwraps2::n_perc0(gear == 5)),
#        "SWLS Mean" = 
#          list("Three" = ~ qwraps2::n_perc0(gear == 3),
#               "Four"  = ~ qwraps2::n_perc0(gear == 4),
#               "Five"  = ~ qwraps2::n_perc0(gear == 5)),
#   ) 



# Left outer: merge(x = df1, y = df2, by = "CustomerId", all.x = TRUE)

# Right outer: merge(x = df1, y = df2, by = "CustomerId", all.y = TRUE)

# Following countries in procrastinate have no match in the HDI data from the web
# Antigua
# Bermuda
# Guam
# Macao
# Puerto Rico
# Taiwan
# Yugoslavia

# Create a new data.frame with columns rearranged with the CLEAN data
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
        
# APPENDIX ********************************************************************************************************************
# procrastinate$Occupation <- gsub("\\bplease specify\\b","*Missing*", # Replace "please specify"
#                             gsub("^$","*Missing*", # Replace "blanks"
#                             gsub("\\babc\\b","*Missing*", # Replace "abc"
#                             gsub("\\bfdsdf\\b","*Missing*", # Replace "abc"
#                             gsub("\\bouh\\b","*Missing*", # Replace "abc"
#                             gsub("\\bProcrastinator\\b","*Missing*", # Replace "abc"
#                             gsub("\\bPlease specify title Manager for Regulat\\b","*Missing*", # Replace "abc"
#                             gsub("\\badmin assist\\b","Administration Assistant", # Replace "abc"
#                             gsub("\\bAdministrative Asistant for Jewelry Stor\\b","Administration Assistant", # Replace "abc"
#                             gsub("\\b'Utterly shiftless arts student'... at p\\b","Student", # Replace "abc"
#                             gsub("\\bairline\\b","*Ambiguous*", # Replace "abc"
#                             gsub("\\b0\\b","*Missing*", procrastinate$Occupation ))))))))))))


# Write CSV in R
# write.csv(procrastinateClean, file = "Test.csv")
# write.csv(HDIMerged, file = "merged.csv", row.names=FALSE )

# Summary and Structure of the original data frame
# summary(procrastinate)

# str(procrastinate)

# glimpse(procrastinate)

# Create a data.frame of  unique occupations
# Occupationsdf <-data.frame(select(procrastinate, RowID, Occupation))


# procrastinate$Alt_Occupation <- gsub("^$","*Missing*", procrastinate$Alt_Occupation)# Replace blank strings with "*Missing*"
# 
# x <- select(procrastinate,RowID,Occupation)

# sort(unique(os))

# c("0" = "*Missing*", 
#   "please specify" = "*Missing*",
#   "abc"="*Missing*",
#   "Academic"="Teacher",
#   "Academic Assistant"="Academic - Administration",
#   "academic/career coach & admin assistant"="Counselor - career Coach",
#   "Account Manager"="Sales - Account Manager",
#   "account planner"="Sales - Account Planner",
#   "Account Service Rep"="Sales - Account Rep",
#   # "Accountant"="Accountant",
#   "Accounting"="Accountant",
#   "Accounting Assistant"="Accountant",
#   "Accounting Manager"="Accountant",
#   "Accounts Payable"="Accountant",
#   "Accounts Payable / Fleet Manager"="Accountant",
#   "acounting analyst"="Accountant",
#   "Activities Leader"="*Ambiguous*",
#   #"Actress"="Actress",
#   #"acupuncturist"="acupuncturist",
#   "adjunct faculty / University + communit"="Professor",
#   "admin assist"="Adminstrative Assistant",
#   "Administration Assistant"="Adminstrative Assistant",
#   "Administrative Asistant for Jewelry Stor"="Admin Assistant",
#   "Administrative Officer"="Administrator",
#   #"Administrator"="Administrator",
#   #"adult care"="adult care",
#   "advocate"="Attorney",
#   #"Agronomist"="Agronomist",
#   "airline"="*Missing*",
#   "airport ground handler"="airport ground handler",
#   #"Analyst"="Analyst",
#   #"anthropologist"="anthropologist",
#   #"Antique Dealer"="Antique Dealer",
#   #"Architect"="Architect",
#   #"Art Director"="Art Director",
#   #"Artist"="Artist",
#   "Artist/ designer/builder"="Artist",
#   "Artist/administrator"="Artist",
#   "artist/designer/homemaker"="Artist",
#   "Assistant"="Administrative Assistant",
#   "Assistant District Attorney"="Attorney",
#   "assistant general counsel"="Attorney",
#   "assistant professor"="Professor",
#   "Assoc. Governmental Program Analyst"="Program Analyst",
#   #"associate"="Associate",
#   "Associate / investment banking"="Banking - Investment associate",
#   "associate at law firm"="Attorney",
#   "Associate Director"="Film/TV - Associate Director",
#   "Associate director/ marketing communicat"="Marketing - Communications",
#   "Associate Producer"="Film/TV - Associate Producer",
#   "asst"="Assistant",
#   "Asst. Pre-school Teacher"="Teacher",
#   "Asst. Prof."="Professor",
#   #"Astrohysicist"="Astrophysicist",
#   #"Attorney"="Attorney",
#   "Attorney-self employed"="Attorney",
#   "audio engineer"="Engineer - Audio",
#   #"Aviation Specialist"="Aviation Specialist",
#   "Bank Teller"="Banking - teller",
#   "banker"="Banking",
#   "Bar & Restaurant Owner"="Restaurant & Bar Owner",
#   #"Bartender"="Bartender",
#   #"Biologist"="Biologist",
#   #"bookkeeper"="Bookkeeper",
#   "bookkeeper/ actor"="Bookkeeper",
#   #"bookseller"="Bookseller",
#   #"Box Office Representative"="Box Office Representative",
#   #"Braillist"="Braillist",
#   #"Budget analyst"="Budget analyst",
#   "business"="Business Owner / Self Employed",
#   "Business / Test Analyst"="IT - Systems Analyst",
#   "BUSINESS CONSULTA"="Business consultant",
#   #"business consultant"="Business consultant",
#   "business manager"="Manager",
#   "Business Owner"="Business Owner / Self Employed",
#   "Business Systems Analyst"="IT - Systems Analyst",
#   "businesswoman"="Business Owner / Self Employed",
#   #"buyer"="Buyer",
#   "C E O/ M D"="CEO",
#   #"CAD operator"="CAD Technician",
#   #"CAD Technician"="CAD Technician",
#   #"Camera Coordinator"="Camera Coordinator",
#   "Campus Planner"="Planner - Campus",
#   "Capstone Golf Course"="*Ambiguous*",
#   "Career Placement Associate"="Counselor - career Placement",
#   #"Case Manager"="Case Manager",
#   "Casting Director"="Film - casting Director",
#   "catholic priest/ full timestudent"="Priest",
#   #"ceo"="CEO",
#   "Certified Nurse's Assistant"="Nursing - Certified Assistant",
#   "chairman of the board"="Chairman",
#   "chauffeur"="Driver",
#   "Chief Financial Officer"="CFO",
#   #"Chief of Staff"="Chief of Staff",
#   "Chiefe Development Engineer"="Engineer - Development",
#   #"chiropractor"="chiropractor",
#   #"Civil servant"="Civil servant",
#   #"clerk"="clerk",
#   "Client Relationship Assistant"="Sales - Client Relationship Assistant",
#   "Clinical Dietitian"="Dietitian - Clinical",
#   #"clinical psychologist"="clinical psychologist",
#   #"Clinical Research Assistant"="Clinical Research Assistant",
#   #"Clinical Trial Assistant"="Clinical Trial Assistant",
#   "Collection management specialist"="Collections",
#   "College Administrator"="Academic - Administration",
#   "college faculty"="Professor",
#   "college professor"="Professor",
#   #"Communications"="Communications",
#   "Communications & Publishing"="Communications & Publishing",
#   "company director"="Director",
#   "Computer Consultant"="IT - Consultant",
#   "Computer Instructor (Continuing Educatio"="Teacher",
#   "Computer Operator"="IT - Systems Analyst",
#   "Computer Programmer"="IT - Software Engineer",
#   "Computer Science"="IT - Systems Analyst",
#   "Computer Systems Analyst"="IT - Systems Analyst",
#   "Computers"="IT Systems Analyst",
#   #"consultant"="Consultant",
#   "Consultant and entrepreneur (small busin"="Business Owner / Self Employed",
#   #"Consulting Manager"="Consulting Manager",
#   "Consumer Case Coordinator"="Case Coordinator - Consumer",
#   "Controller"="Financial Controller",
#   "Contsuruction Management"="Construction Management",
#   "Coordinator of International Programs"="Program Coordinator",
#   "coordinatore operativo"="Operations - Coordinator",
#   "Co-Proprietor"="Business Owner / Self Employed",
#   #"copy supervisor"="copy supervisor",
#   #"Copy Writer"="Copy Writer",
#   "Corporate instructor"="Corporate Trainer",
#   #"Corporate Trainer"="Corporate Trainer",
#   "Corporation President"="President",
#   "Corrections"="Corrections Officer",
#   #"Counselor"="Counselor",
#   "Country Style Employee"="*Ambiguous*",
#   #"Creative Consultant"="Creative Consultant",
#   #"Creative Director"="Creative Director",
#   "CRNA"="Nursing - Certified Registered Anesthetist",
#   #"Customer Service"="Customer Service",
#   "Customer Service at Domino's Pizza"="Customer Service",
#   #"Dance teacher"="Dance teacher",
#   "Data Warehouse Engineer"="IT - DW Engineer",
#   "Dealer"="*Ambiguous*",
#   "Dental & Disability Coordinator"="Dental & Disability Coordinator",
#   #"dentist"="Dentist",
#   "Dept. Director (Non-profit)"="Non Profit - Director",
#   "Deputy Chief of Public Information for t"="Public Information - Deputy Chief",
#   "Deputy Chieif Information Officer"="IT - CIO (Deputy)",
#   #"Deputy Director"="Deputy Director",
#   "deputy practice manager"="*Ambiguous*",
#   #"designer"="Designer",
#   "detail checker"="*Ambiguous*",
#   "Developer"="IT Software engineer",
#   #"Dietitian"="Dietitian",
#   "Diplomat"="Foreign Affairs",
#   #"director"="Director",
#   "Director / information technology"="IT - Director",
#   "Director of a language program"="Language - Program Director",
#   "Director of Academic Affairs"="Academic - Administration (Director)",
#   "Director of business development"="Business Development - Director",
#   "Director of Contract Management"="Contract Management - Director",
#   "Director of non-profit organization"="Non Profit - Director",
#   "Director of Software Company"="Director",
#   "Director Operations"="Operations - Director",
#   "Disability Allowance"="*Ambiguous*",
#   "Dish Washer"="Dishwasher",
#   "Divisional Manager of a large cosmetics"="Director",
#   "Doctor Research"="Physician - Research",
#   "Doctor; Physician"="Physician",
#   #"Driver"="Driver",
#   "Early child hood teacher"="Teacher",
#   "Early Childhood Education Student/ Nanny"="Student",
#   # "Ecology technician"="Ecology technician",
#   # "Economist"="Economist",
#   "Economy"="Economist",
#   #"Editor"="Editor",
#   "Editor Attorney"="Attorney",
#   "education"="Teacher",
#   "Education (at a university)"="Professor",
#   "education administration"="Academic - Administration",
#   "Education Specialist"="Academic - Administration",
#   "Educator/Student"="Teacher",
#   "EFL Teacher/ Professional Researcher"="Teacher",
#   "EHS Manager"="Environmental - EHS Manager",
#   #"election services"="election services",
#   "Electrical Technician"="Electrician",
#   #"electronic technician"="electronic technician",
#   "employed by a church"="*Ambiguous*",
#   #"EMT"="EMT",
#   "energy therapist"="Therapist - Energy",
#   #"engineer"="Engineer",
#   #"enologist"="enologist",
#   #"entertainer"="Entertainer",
#   "entrepreneur"="Business Owner / Self Employed",
#   "Entrepreneur & Consultant"="Business Owner / Self Employed",
#   #"Environmental Analyst"="Environmental Analyst",
#   "environmental education non profit direc"="Environmental - Education/Non Profit",
#   #"Environmental Engineer"="Environmental Engineer",
#   "Environmental Senior Specialist"="Environmental Specialist",
#   "EOD"="Military - Explosive Ordinance Disposal",
#   "Epidemiologist"="Physician - Epidemiologist",
#   "ESL Teacher/Biologist"="Teacher",
#   #"Executive"="Executive",
#   #"Executive Assistant"="Executive Assistant",
#   #"Executive Director"="Executive Director",
#   #"Executive officer"="Executive officer",
#   "Executive Vice President / Senior Lender"="Vice President",
#   #"Facilitator"="Facilitator",
#   #"Facilities Management"="Facilities Management",
#   #"Farm Manager"="Farm Manager",
#   "fdsdf"="*Missing*",
#   "federal excise tax auditor"="Tax Auditor",
#   #"Field Coordinator"="Field Coordinator",
#   "film editor"="Film - Editor",
#   "Film Industry/Miscelanious"="Film - Other",
#   "Film maker"="Film - Maker",
#   #"Finance"="Finance",
#   #"Financial Advisor"="Financial Advisor",
#   #"financial analyst"="financial analyst",
#   #"Financial Consultant"="Financial Consultant",
#   #"Financial Controller"="Financial Controller",
#   "financial officer / small career-trainin"="financial officer",
#   #"financial risk manager"="financial risk manager",
#   "First VP & Associate General Counsel"="Attorney",
#   "Fitness Assistant / wellness mentor / ca"="Fitness Instructor - Wellness mentor",
#   #"Fitness Instructor"="Fitness Instructor",
#   #"flight surgeon"="flight surgeon",
#   #"Food Department Director"="Food Department Director",
#   #"Food Service Supervisor"="Food Service Supervisor",
#   #"Foreign Affairs Specialist"="Foreign Affairs",
#   "Framer/Sales Associate"="Framer",
#   "free lance bookkeeper"="Bookkeeper",
#   "Free lance editor and tutor--in theory"="Editor - Freelance",
#   "free professionist"="Business Owner / Self Employed",
#   "Freelance"="Business Owner / Self Employed",
#   "Freelance ESL Teacher"="Teacher",
#   "Freelance musician / part time EMT / pri"="Musician",
#   "Freelance Project Manager"="Project Manager",
#   "full time student and part time bartende"="Student",
#   "Full-Time Mother / Part-Time Editor"="home maker",
#   "fulltime office assistant"="Office Assistant",
#   "Gender/Public Health Consultant"="Public Health - Consultant",
#   #"Geologist"="Geologist",
#   #"Geophysicist"="Geophysicist",
#   "Gove service"="Civil servant",
#   #"Graduate Assistant"="Graduate Assistant",
#   "Graduate Research Assistant"="Graduate Assistant - Research",
#   "Graduate Researcher"="Researcher - Graduate",
#   "Graduate student/University instructor"="Student",
#   "Graduate student--research and teaching"="Student",
#   #"Grants Administrator"="Grants Administrator",
#   #"Graphic Designer"="Graphic Designer",
#   "Grease Monkey"="*Ambiguous*",
#   "Grocery Store Salesman"="Grocery Store Salesman",
#   #"Groundskeeper"="Groundskeeper",
#   "Head - Operations & QA"="Operations & QA",
#   "health care"="Healthcare",
#   "Healthcare Consultant"="Healthcare - Consultant",
#   #"home maker"="home maker",
#   "host"="Restaurant - Host/Hostess",
#   "hostess"="Restaurant - Host/Hostess",
#   "Hotel Desk Clerk"="Hospitality - Desk Clerk",
#   "Housekeeping"="Hospitality - Housekeeping",
#   "houswife"="home maker",
#   #"HR generalist"="HR generalist",
#   "Human Resource Manager"="HR Manager",
#   "Human Resource Manger"="HR Manager",
#   #"HVAC Tech"="HVAC Tech",
#   #"ICT Director"="ICT Director",
#   "information assisstant"="IT - Assistant",
#   "Information Developer"="IT - Software engineer",
#   "Information Management"="IT - Manager",
#   "Information technology"="IT",
#   "Information Technology Consultant"="IT - Consultant",
#   "In-house Legal Counsel"="Attorney",
#   "innkeeper"="Hospitality - innkeeper",
#   "Instructional Assistant Online"="Instructor - Online Assistant",
#   "instructor / coach"="Instructor - Coach",
#   #"Insurance"="Insurance",
#   #"Insurance Agent"="Insurance Agent",
#   #"insurance broker's assistant"="insurance broker's assistant",
#   #"Insurance Claims Supervisor"="Insurance Claims Supervisor",
#   #"Insurance Coordinator"="Insurance Coordinator",
#   "intern"="*Ambiguous*",
#   "Internet & media consultant"="Media & Internet - Consultant",
#   "Internship"="*Ambiguous*",
#   "interpreter"="Translator / Interpreter",
#   #"Investigative Specialist"="Investigative Specialist",
#   "Investment Assistant"="Banking - Investment Assistant",
#   "investment banker"="Banking - Investment banker",
#   "Investment Counsel"="Banking - Investment Counselor",
#   "ISTraining Coordinator"="IT - Training Coordinator",
#   #"IT"="IT",
#   "IT admin"="IT Administrator",
#   #"IT Administrator"="IT Administrator",
#   #"IT analyst"="IT analyst",
#   #"IT Assistant"="IT Assistant",
#   #"IT consultant"="IT Consultant",
#   #"IT director"="IT Director",
#   #"IT Engineer"="IT Engineer",
#   #"IT Manager"="IT Manager",
#   #"IT security consultant"="IT security consultant",
#   #"IT Specialist"="IT Sepcialist",
#   "IT Support"="IT - Support Engineer",
#   #"IT Support Engineer"="IT Support Engineer",
#   "IT systems administrator"="IT - Systems Analyst",
#   "IT Technician"="IT - Support Engineer",
#   #"Janitor"="Janitor",
#   "jewelry artist"="Artist - jewelry",
#   #"Journalist"="Journalist",
#   "journalist (freelance)"="Journalist",
#   "Juvenile Corrections Officer"="Corrections Officer - Juvenile",
#   "Lab Director/Archeologist"="Lab Director",
#   "Lab Services Assistant"="Lab  Assistant",
#   #"Labor Relations Specialist"="Labor Relations Specialist",
#   "laboratory technician"="Lab Technician",
#   "laborer (construction)"="Construction",
#   "land use planner"="Planner - land use",
#   #"landscape designer"="Landscape Designer",
#   #"Language Service Provider"="Language Service provider",
#   #"language trainer"="Language Trainer",
#   "Law clerk"="Legal Clerk",
#   #"law enforcement"="Police Officer",
#   "lecturer"="Professor",
#   #"Legal Assistant"="Legal Assistant",
#   "Legal Assistant / Office Manager"="Legal Assistant / Office Manager",
#   #"Legal Secretary"="Legal Secretary",
#   #"Legislation Analyst"="Legislation - Analyst",
#   #"letter carrier"="letter carrier",
#   #"Librarian"="Librarian",
#   "Library Assistant"="Librarian Assistant",
#   "library paraprofessional"="Librarian",
#   "Library technician"="Librarian",
#   #"Licensed Professional Counselor"="Counselor - Professional",
#   #"Life Guard"="Life Guard",
#   "Lift Ops"="Lift Operator",
#   "LPN"="Nursing - Licensed Practical",
#   "maintenance tech."="Maintenance technican",
#   #"Management consultant"="Management consultant",
#   "Management Consultant & Entrepreneur"="Management consultant",
#   #"manager"="Manager",
#   "Manager - Analytical and Environmental S"="Environmental - Analytical Manager",
#   "manager IT"="IT - Manager",
#   #"manufacturing"="manufacturing",
#   "Market Analyst"="Marketing Research Analyst",
#   "Market Research Analyst"="Marketing Research Analyst",
#   "Marketing"="Marketing",
#   #"marketing copywriter"="marketing copywriter",
#   #"Massage Therapist"="Massage Therapist",
#   #"Master Control Operator"="Master Control Operator",
#   "md"="*Ambiguous*",
#   "Mechanical Engineer"="Engineer - mechanical",
#   #"Media Consultant"="Media Consultant",
#   #"Media Relations Manager"="Media Relations Manager",
#   #"media relations/science writing"="media relations/science writing",
#   #"Medical"="Medical",
#   #"Medical / Public Health Educator"="Medical / Public Health Educator",
#   #"Medical Laboratory"="Medical Laboratory",
#   #"Medical Practitioner"="Medical Practitioner",
#   #"medical sonographer"="medical sonographer",
#   #"medical transcriptionist"="medical transcriptionist",
#   #"Mentor/Special Events intern"="Mentor/Special Events intern",
#   #"Military"="Military",
#   "mktg"="Marketing",
#   #"Mover"="Mover",
#   #"Multimedia Developer"="Multimedia Developer",
#   #"museum docent"="museum docent",
#   #"Musician"="Musician",
#   "musician/student/teacher"="Musician",
#   "na"="*Missing*",
#   #"Nanny"="Nanny",
#   "Nanny and student"="Nanny",
#   "Network Engineer"="IT Network Engineer",
#   "Network Services Engineer"="IT Network Engineer",
#   "new realtor"="Realtor",
#   "newspaper carrier"="Newspaper delivery",
#   "Non-profit Consultant"="Non-profit Consultant",
#   #"Nurse"="Nurse",
#   #"nursing home"="Nursing home",
#   "office"="Office Admin",
#   #"Office Admin"="Office Admin",
#   #"Office Manager"="Office Manager",
#   "Office Manager / Accountant"="Office Manager",
#   "Office Services Manager"="Office Manager",
#   "Online Media Buyer"="Buyer - Online Media",
#   #"operations manager"="Operations manager",
#   "Organic Grocery Store Cashier/shift lead"="Cashier",
#   "Ornithology Graduate Student and Teachin"="Student",
#   "ouh"="*Missing*",
#   #"Outdoor Recreation Coordinator"="Outdoor Recreation Coordinator",
#   "Owner"="Business Owner / Self Employed",
#   "owner - private practice physical therap"="Physical Therapist",
#   "Page Designer for a newspaper"="Graphic Designer",
#   #"Paralegal"="Paralegal",
#   "Paraprofessional"="*Ambiguous*",
#   "Parent Educator/Supervisor"="home maker",
#   "Partner"="*Ambiguous*",
#   #"pathology"="Pathology",
#   #"PCA"="PCA",
#   "PCA for a quadrapilegic and a PCA for a"="PCA - Quadriplegic",
#   "Pharmaceutical Merchandiser"="Merchandiser - Pharmaceutical",
#   #"Pharmacist"="Pharmacist",
#   "pharmacy tech."="Pharmacist",
#   "phd student researcher"="Student",
#   "photo profucer"="Photographer",
#   #"Physical Science Technician"="Physical Science Technician",
#   "physician (internist)"="Physician - Intern",
#   #"Physicist"="Physicist",
#   "Physiotherapst"="Physiotherapst",
#   "pjublic relations director"="Public Relations",
#   #"Plant Engineering Supervisor"="Plant Engineering",
#   
#   #"please specify"="*Missing*",
#   "Please specify title Manager for Regulat"="*Missing*",
#   
#   #"policy analyst"="Policy Analyst",
#   "Post Grad Physician"="Physician - Post Grad",
#   "Postdoc"="Student - Post Doctoral",
#   "Postdoctoral Researcher"="Researcher - Post Doctoral",
#   "pr and communications firm owner"="Public Relations",
#   #"President"="President",
#   "President Nongovernmental organization"="President - NGO",
#   "president/CEO"="CEO",
#   #"Press Officer"="Press Officer",
#   #"Private Equity Principal"="Private Equity",
#   "Probation Supervisor"="Probation officer",
#   "Process Engineer"="Engineer - Process",
#   "Procrastinator"="*Missing*",
#   "Produce Associate"="Grocery Store - produce associate",
#   "producer"="Film - Producer",
#   #"Product Field Test Manager"="Product Field Test Manager",
#   "Production Operations Support Analyst"="Operations - Production Support Analyst",
#   "Professional Organizer"="Organizer - professional",
#   "Professional Soccer Player"="Soccer Player - Professional",
#   #"Program Assistant"="Program Coordinator",
#   #"Program Coordinator"="Program Coordinator",
#   #"Program Director"="Program Director",
#   #"Program director at a non-profit organiz"="Program director at a non-profit organiz",
#   #"Program Manager"="Program Manager",
#   #"Program Manager and Acting Director"="Program Manager",
#   #"Program officer"="Program Manager",
#   #"Program Specialist"="Program Specialist",
#   "Programmer"="IT Software engineer",
#   "Programmer Analyst"="IT Software engineer",
#   "Programmer/Developer"="IT Software engineer",
#   "Programmer/Software Analyst"="IT Software engineer",
#   #"Project Manager"="Project Manager",
#   #"Proofreader"="Proofreader",
#   "Proposal Director"="Contract/Proposal - Director",
#   #"Psychiatrist in Private Practice"="Psychiatrist",
#   "psychologis"="Psychologist",
#   #"psychotherapist"="Psychotherapist",
#   "P-T College Faculty & P-T Self-Employed"="Professor",
#   #"Public Health"="Public Health",
#   #"public relations"="Public Relations",
#   #"Publishing"="Publishing",
#   #"quad racer"="quad racer",
#   #"Quality Manager"="Quality Manager",
#   #"Quotations specialist"="Quotations specialist",
#   "real estate"="Real estate agent",
#   #"real estate agent"="Realtor",
#   #"Real Estate Appraiser"="Real Estate Appraiser",
#   "real estate broker"="Realtor",
#   "Real estate developer"="Real Estate Developer",
#   "realtor"="real estate agent",
#   "Reasearch assistant"="Research Assistant",
#   "Receptionist"="Receptionist",
#   "Recreational Staff"="Recreational Staff",
#   "Regional Sales Manager"="Sales - Manager",
#   "Registered Respiratory Therapist"="Respiratory - Therapist",
#   #"regulatory affairs"="regulatory affairs",
#   #"Research / GIS analyst"="Research -  Analyst",
#   #"Research Analyst"="Research -  Analyst",
#   #"Research Assistant"="Research Assistant",
#   #"Research Associate"="Research Associate",
#   #"research coordinator"="research coordinator",
#   #"Research intern"="Research intern",
#   #"Research manager"="Research manager",
#   #"Research Scholar"="Research Scholar",
#   #"Research Scientist"="Research Scientist",
#   #"research specialist"="research specialist",
#   #"research technician"="research technician",
#   #"Research/Teaching Assistant"="Teaching Assistant",
#   #"researcher"="researcher",
#   #"Researcher - Physician"="Researcher - Physician",
#   "Residence Don"="Residential Services - Supervisor",
#   "resident physician"="Physician",
#   #"Residential Services Supervisor"="Residential Services - Supervisor",
#   #"Respiratory Therapist"="Respiratory Therapist",
#   "restaurant mgr / student / and looking f"="Restaurant Operations - Mgr",
#   #"Restaurant operations manager"="Restaurant Operations - Mgr",
#   #"Retail"="Retail",
#   "Retail / artist /writer"="Retail",
#   #"retired"="Retired",
#   "retired/adjunct"="Retired",
#   "RN"="Nurse - RN",
#   "RN - Medical Sales"="Sales - medical",
#   "rocket scientist"="Scientist - Rocket",
#   "s"="*Missing*",
#   #"Sales"="Sales",
#   #"Sales executive"="Sales - Executive",
#   #"Sales Expert"="Sales",
#   #"sales insurance"="Insurance - Sales",
#   #"sales manager"="Sales - Manager",
#   #"Sales Rep"="Sales - Rep",
#   #"Sales/ daycare worker"="Sales",
#   "school"="Student",
#   "School Counselor"="Counselor - School",
#   "Science writing intern"="Writer - Science (intern)",
#   #"Scientist"="Scientist",
#   "secretary"="Admin Assistant",
#   "Self Employed"="Business Owner / Self Employed",
#   "Self employed Public Relations"="Public Relations",
#   "self employeed"="Business Owner / Self Employed",
#   "Self-Employed / personal trainer / stren"="Personal Trainer",
#   "Self-employed Family Therapist"="Therapist - Family",
#   "self-employed freelance writer/author"="Writer/Author - Freelance",
#   "self-employed Photographer"="Photographer",
#   "self-employed translator"="Translator",
#   "Self-employed writer/editor"="Writer/Author - Freelance",
#   "selfemplyed renovator"="Renovator",
#   #"Senate Page"="Senate Page",
#   "senior consultant"="Consultant Sr.",
#   "Senior Consultant Programmer/Analyst"="IT Programmer - Consultant",
#   #"Senior Grant Officer"="Grant officer - Senior",
#   "Senior Human Resources Consultant"="HR Consultant",
#   "Senior Policy Advisor"="Policy Advisor",
#   "senior project manager"="Project Manager",
#   "Senior Records Analyst"="Records Analyst",
#   "Senior Staff Writer"="Writer",
#   "Senior Systems Analyst"="IT Systems Analyst",
#   "Server"="Restaurant - Food Server",
#   #"Service co-ordinator"="Service Coordinator",
#   "Service Registrar/English Instructor"="Teacher",
#   #"set designer"="set designer",
#   #"set lighting technician"="set lighting technician",
#   "Shipping/receiving/warehouse mgnt"="Warehousing",
#   #"Social Media consultant"="Social Media consultant",
#   #"Social Policy Analyst"="Social Policy Analyst",
#   #"Social Work Intern"="Social Worker",
#   #"Social Worker"="Social Worker",
#   "Software analyst"="IT Software engineer",
#   "Software Developer"="IT Software engineer",
#   "Software engineer"="IT Software engineer",
#   "Software Pro"="IT Software professional",
#   "Software Sales"="Sales - Software",
#   "Software trainer"="Training -  Software",
#   #"Speaker Author Consultant"="Speaker",
#   #"Speaker/Actor"="Speaker",
#   #"Special Education Administrative Assista"="Special Ed - Admin Asst.",
#   #"special education teacher"="Special Ed - Teacher",
#   "Special Projects Editor"="Editor - Special Projects",
#   "specialist"="*Ambiguous*",
#   "Speech and language Assistant"="language and Speech Assistant",
#   "Sr. Drug Safety Associate"="Drug Safety",
#   #"Staff Writer at a magazine"="Staff Writer",
#   #"Statistician"="Statistician",
#   "Stay-at-home dad"="home-maker",
#   #"steamship agent"="steamship agent",
#   #"stocker"="stocker",
#   #"student"="Student",
#   #"Student / working part-time"="Student",
#   #"Student and Administrative Assistant"="Student",
#   #"Student and part time secretary"="Student",
#   #"Student and Private Curator"="Student",
#   #"student childhood and youth studies"="Student",
#   #"student fysiotherapy /home care / massage"="Student",
#   #"Student part-time and sales full-time"="Student",
#   #"student/barmaid"="Student",
#   #"student/imvestor"="Student",
#   #"student/retail"="Student",
#   #"Student/Teacher"="Student",
#   #"student/waiter"="Student",
#   "Studey"="Student",
#   "supervising program development speciali"="Program Development Specialist",
#   "Supervisor"="*Ambiguous*",
#   "supervisor shelderd workshop for handcap"="Social Worker - Handicap",
#   #"Surgeon"="Surgeon",
#   "Surgical Resident"="Surgeon - resident",
#   "System Analyst"="IT Systems Analyst",
#   "system manager"="IT Systems Analyst",
#   "Systems Analyst"="IT Systems Analyst",
#   "Systems Programmer/Analyst"="IT Systems Analyst",
#   #"tax consultant"="tax consultant",
#   #"Tax Examiner"="Tax Examiner",
#   #"teacher"="Teacher",
#   #"teacher / Administrator"="Teacher",
#   #"Teacher and Full Time Doctoral Student"="Teacher",
#   #"Teacher assistant"="Teaching Assistant",
#   #"teacher's assistant/afterschool leader"="Teaching Assistant",
#   #"Teaching Assistant/Graduate student"="Teaching Assistant",
#   #"Tech Analyst/GIS"="IT - tech analyst/GIS",
#   "Tech Support"="Technical Support",
#   #"Technical Coordinator"="Technical Coordinator",
#   #"Technical director"="Technical director",
#   #"Technical officer"="Technical officer",
#   #"Technical support rep"="IT - Support",
#   #"Technical Trainer"="Training - Technical",
#   #"Technical Writer"="Technical Writer",
#   "Technology (CTO)"="IT - CTO",
#   "Technology Curriculum Developer Science"="Technology Curriculum Developer Science",
#   #"Telemarketer"="Telemarketer",
#   #"television director"="Television - Director",
#   #"Television Producer"="Television - Producer",
#   "Temp"="*Ambiguous*",
#   "temporary office"="*Ambiguous*",
#   "Test Item Writer (Self-employed)"="Writer - Testing",
#   #"Theater artist/ Teacher"="Theater Artist",
#   #"Theater General Manager"="Theater - GM",
#   "Tour Guide"="Tour Guide",
#   #"Town Clerk"="Town Clerk",
#   "Town Planner"="Planner - Town",
#   #"trader"="Trader",
#   "Traffic Reporter-Radio"="Reporter - Traffic",
#   "trainee"="*Ambiguous*",
#   #"Training Coordinator"="Training - Coordinator",
#   #"Translator"="Translator",
#   #"treatment support co-ordinator"="treatment support co-ordinator",
#   #"Tutor"="Tutor",
#   #"TV BROADCAST TECHNICIAN"="Television - technician",
#   #"TV News Executive Producer"="Television - Producer",
#   #"Unemployed"="Unemployed",
#   "university faculty"="Professor",
#   "University Staff"="Academic - Administration",
#   "Urban Planner/Economic Development Plann"="Planner - Urban",
#   "'Utterly shiftless arts student'... at p"="Student",
#   #"veterinarian"="veterinarian",
#   "Vetrans Representative"="Veterans Representative",
#   #"vice president"="Vice President",
#   #"Vice President / program office"="Programs - VP",
#   #"vice-president"="Vice President",
#   "vidoe"="Videographer",
#   #"visual artist"="Artist - Visual",
#   "VMD"="*Ambiguous*",
#   #"Volunteer Director"="Volunteer - Director",
#   #"volunteer mental health worker"="Mental Health worker",
#   "VP Scientific Affairs / pharmaceutical c"="Scientific Affairs - VP"
#   #"warehouse"="Warehousing",
#   #"Warehouse Supervisor"="Warehousing",
#   #"Web Communications"="Web Communications",
#   #"Web Designer"="Web Designer",
#   #"Webmaster / Print Designer"="Webmaster / Print Designer",
#   #"wig designer"="wig designer",
#   #"writer"="Writer",
#   #"Writer & Director of Content Solutions"="Writer",
#   #"Writer / eductor"="Writer",
#   #"writer / lecturer / consultant"="Writer",
#   #"Writer / web designer/ web-master"="Writer",
#   #"Writer and management consultant"="Writer",
#   #"writer/editor"="Writer",
#   #"Writer/editor/musician"="Writer",
#   #"writer/musician"="Writer",
#   #"Writing Consultant"="Writer",
#   #"yoga teacher"="Yoga Instructor"
# )) 
               


# # Remove extraneous columns
# VHigh_HDI_df <- select(VHigh_HDI_df,Country=X3,HDI=X4)
# High_HDI_df <- select( High_HDI_df,Country=X3,HDI=X4)
# Med_HDI_df <- select(  Med_HDI_df,Country=X3,HDI=X4)
# Low_HDI_df <- select(  Low_HDI_df,Country=X3,HDI=X4)
# 
# # Remove extraneous rows    
# VHigh_HDI_df <- VHigh_HDI_df[ which(VHigh_HDI_df$Country != c("Rank","Country")), ] 
# VHigh_HDI_df <- VHigh_HDI_df[ which(VHigh_HDI_df$Country != "Change in rank from previous year[1]"), ]
# High_HDI_df <-  High_HDI_df[ which( High_HDI_df$Country != "Rank"), ] 
# High_HDI_df <-  High_HDI_df[ which( High_HDI_df$Country != "Country"), ] 
# High_HDI_df <-  High_HDI_df[ which( High_HDI_df$Country != "Change in rank from previous year[1]"), ]
# Med_HDI_df <-   Med_HDI_df[ which(  Med_HDI_df$Country != c("Rank","Country")), ] 
# Med_HDI_df <-   Med_HDI_df[ which(  Med_HDI_df$Country != "Change in rank from previous year[1]"), ]
# Low_HDI_df <-   Low_HDI_df[ which(  Low_HDI_df$Country != c("Rank","Country")), ] 
# Low_HDI_df <-   Low_HDI_df[ which(  Low_HDI_df$Country != "Change in rank from previous year[1]"), ]

# HDI_raw <- read.csv("webscrape.csv", 
#                     na.strings = "NA", 
#                     blank.lines.skip = TRUE,
#                     sep = ",",
#                     strip.white = TRUE)