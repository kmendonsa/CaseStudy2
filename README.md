# CaseStudy2

# Introduction 

Procrastination - A global view . WORK IN PROGRESS

# Repo Organization 

The Git Hub was logically organized to make review, commits, and accessibility easy for all contributors and clients. The following folders can be found int he root directory: 

All these repo are contained within the parent repo, CaseStudy2

Data - This repo contains all the data related to the project. This data will be described in detail in later sections but the two key files are the procrastination.csv file and the data scraped from wikipedia on Human Development Index.

Other - This repo contains working files of the entire project. Individual sections of the Case Study can be found here. 

Paper - The objectives of the case study are stored in this repo. 

Source - Thsi repo contains the final Rmarkdown and HTML outputs for the case study.

# Procrastination Data Set 

File is labeled Procastination.csv and can be found in the Data repo. An explanation of the variables is provided below:

Age: The participant’s age in years.

Gender: The gender the participant identifies as (Male or Female)

Kids: Binary, whether they have kids or not.

Edu: Education level

Work Status: What kind of job are they working?

Annual Income: All converted to dollars.

Current Occupation: A write-in for occupation.

How long have you held this position?: Years: Number of years in this job.

How long have you held this position?: Months: Number of months in this job.

Community: Size of community

Country of Residence: The country where the person holds citizenship.

Marital Status: Single, Married, Divorced, Separated, etc.

Number of sons/Number of daughters: integer number of children.

All variables starting DP – the Decisional Procrastination Scale (Mann, 1982)

All variables starting AIP – Adult Inventory of Procrastination (McCown & Johnson, 1989)

All variables starting GP – the General Procrastination scale (Lay, 1986)

All variables starting SWLS – the Satisfaction with Life Scale (Diener et al., 1985)

Do you consider yourself a procrastinator?: a binary response

Do others consider you a procrastinator?: a binary response

Computed column: DPMean - mean of the DP survey variable

Computed column: AIPMean - mean of the AIP survey variable

Computed column: GPMean - mean of the GP survey variable

Computed column: SWLSMean - mean of the SWLS survey variable


There were several survey questionnaire types that are not defined in the data set: DP, AIP, GP, and SWLS. We will explain the concepts of these questions so that it may be properly interpreted. 

GP:General Procrastination Scale

The General Procrastination scale is used for people to describe a wide variety of activites associated with procrastinatoin. It is a 5-point scale: (1 - Extremely uncharacteristic 3 - Netural 5 - Extremeley Characterisitc). An Example of this question type includes, "When it is time to get up in the morning, I most often get right out of bed. "

Source: http://www.sciencedirect.com/science/article/pii/0092656686901273?via%3Dihub

DP: Decisoinal Procrastination Scale 

This scale is often regarded as the only reliable measure of indecision. The objective of this method is to measure the the tendency of participants to put off decisions by some other task or activity. An example used in this survey includes, "I don’t make decisions unless I really have to."

Source: https://www.researchgate.net/profile/Joseph_Ferrari3/publication/232562755_Decisional_procrastination_Examining_personality_correlates/links/5556ae4d08ae6943a8734cc2/Decisional-procrastination-Examining-personality-correlates.pdf

AIP: Adult Inventory of Procrastination 

The AIP measures the tendency for individuals to postpone tasks under differing circumstances. It is most often used as a measure of procrastination due to fear, procrastination due to a lack of skills, or procrastination to protect ones self-esteem from failure. Answers are submitted on a 5 point scale: (1 = strongly disagree; 5 = strongly agree). Examples of qeustions include, “I am not very good at meeting deadlines.”

Source: https://www.researchgate.net/publication/279532373_Adult_Inventory_of_Procrastination_Scale_AIP_A_comparison_of_models_with_an_Italian_sample


SWLS: Satisfied With Life Scale 

SWLS is typically a concise 5-item insturment used to underantd and measure global cognitice judgements pertaining to the satification of a participants time. These survey questions do not weight the imporatnce of any one particular area of an individuals life, but rather allow individuals to factor in all aspects of thier life. An example used in the procrastination survey, "I am satisfied with my life" doesn't ask about a specific aspect, but rather a broad representation. 

Source: https://internal.psychology.illinois.edu/~ediener/SWLS.html

# WebScrape.CSV

This data was scraped from Wikipedia and contains Human Development Attibutes for 189 countries. The variables are described below: 

HDICategory: Categoriztion of the coutnries into 4 variables of HDI (Very High, High, Medium, Low)

Rank2016_15: Individual countries rank for the calendar year '15-'16

RankChange: How many positions the country changed in overall ranking 

Country: Countries involved in the study 

HDI2016_15: Human Development Index (HDI) score for the calendar year '15-'16

HDIChngYoY: Meaure (%) as to the change in HDI over the last year
