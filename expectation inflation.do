*************************************************************************************************************************************
* New York Survey of Consumer Expectations 
************************************************************************************************************************************
clear
use "C:\Users\22031\Downloads\SCE_MICRODATA.dta" 
*Drop inflation values greater than 100, because they are outliers
drop if Q8v2part2>100

************************************************************************************************************************************
*Average Inflation expectation overtime
************************************************************************************************************************************
*Generate average inflation expectation
by date,sort: egen mean_expected_inflation=mean(Q8v2part2)
//plot a twoway line graph to see the fluctuation of expected inflation over time
twoway (line mean_expected_inflation date)
***************************************************************************************************************************************
*Percentiles of inflation expectations overtime
***************************************************************************************************************************************
*Generate  Percentiles of inflation expectations overtime
by date, sort: egen p25 = pctile( Q8v2part2 ) if Q8v2==1, p(25)
by date, sort: egen p50 = pctile( Q8v2part2 ) if Q8v2==1, p(50) 
by date, sort: egen p75 = pctile( Q8v2part2 ) if Q8v2==1 , p(75) 
// plot a twowayline graph for p25 p50 p75 to see the fluctuation over time
twoway (line p25 p50 p75 date)

*Label the values in 	Q33 using 1 Female and 2 Male, as defined in the questionnaire
label values Q33 gender
label define gender 1"Female" 2"Male"
// rename Q33 as Gender
rename Q33 Gender

************************************************************************************************************************************
*Differences in average expectations across different elicitation methods
************************************************************************************************************************************
//here we first generate mean expection of subjective inflation of each of the bin from 1 to 5
by date, sort:egen Q9_bin1_mean =mean( Q9_bin1 )
by date, sort:egen Q9_bin2_mean =mean( Q9_bin2)
by date, sort:egen Q9_bin3_mean =mean( Q9_bin3)
by date, sort:egen Q9_bin4_mean =mean( Q9_bin4)
by date, sort:egen Q9_bin5_mean =mean( Q9_bin5)
// Now generate the overall mean of the inflation expectation 
egen subj_expected_inflation=rowmean( Q9_bin1_mean Q9_bin2_mean Q9_bin3_mean Q9_bin4_mean Q9_bin5_mean)
// We can now have a twoway plot of point estimates mean and subjective distribution of inflation
twoway line subj_expected_inflation mean_expected_inflation date

*************************************************************************************************************************************
*Differences in average inflation expectations across demographic groups such as gender, in- come groups, or education groups
*************************************************************************************************************************************
*generate average inflation expectation for Male and Female
by date,sort: egen Female=mean(Q8v2part2) if Gender==1
by date,sort: egen Male=mean(Q8v2part2) if Gender==2
*Plot a twoaway line graph to see the dynamic of expected inflation between Male and Female
twoway (line Female Male date), title("Gender") name(Gender, replace)

*Generate average inflation expectation for Education across various categories
codebook _EDU_CAT
//drop missing
drop if missing(_EDU_CAT)
// Now generate avaerage inflation expectation for all the categories
by date,sort: egen College=mean(Q8v2part2) if _EDU_CAT =="College"
by date,sort: egen High_School=mean(Q8v2part2) if _EDU_CAT =="High School"
by date,sort: egen Some_College=mean(Q8v2part2) if _EDU_CAT =="Some College"
//plot a twoway line graph over time
twoway (line College High_School Some_College date), title("Education") name(Education, replace)

*Generate average inflation expectation for Household Income across various categories

codebook _HH_INC_CAT
//drop missing
drop if missing( _HH_INC_CAT)
// Now generate avaerage inflation expectation for all the categories
by date,sort: egen Fiftyk_to_Hundredk=mean(Q8v2part2) if _HH_INC_CAT =="50k to 100k"
by date,sort: egen over_Hundredk=mean(Q8v2part2) if _HH_INC_CAT =="Over 100k"
by date,sort: egen Under_Fiftyk=mean(Q8v2part2) if _HH_INC_CAT =="Under 50k"
//Plot a twoway line graph
twoway (line Fiftyk_to_Hundredk over_Hundredk Under_Fiftyk date), title("Income")name(Income, replace)
graph combine Gender Education Income

****************************************************************************************************************************
*Document other heterogeneties that you think could be interesting and comment on why you chose these subgroups in the report 
************************************************************************************************************************

*Generate average inflation expectation for all age categories across various categories
codebook _AGE_CAT
//drop missing
drop if missing( _AGE_CAT)

// Now generate avaerage inflation expectation for all the categories

by date,sort: egen fourty_to_sixty=mean(Q8v2part2) if _AGE_CAT =="40 to 60"
by date,sort: egen Over_sixty=mean(Q8v2part2) if _AGE_CAT =="Over 60"
by date,sort: egen Under_Fourty=mean(Q8v2part2) if _AGE_CAT == "Under 40"
//Twoway line graph
twoway (line fourty_to_sixty Over_sixty Under_Fourty date), title("Age") name(Age, replace) 

*Generate average inflation expectation for all regions over time
codebook _REGION_CAT
//drop missing
drop if missing( _REGION_CAT)
by date,sort: egen midwest =mean(Q8v2part2) if _REGION_CAT =="Midwest"
by date,sort: egen Northeast =mean(Q8v2part2) if _REGION_CAT =="Northeast"
by date,sort: egen South=mean(Q8v2part2) if _REGION_CAT =="South"
by date,sort: egen  West=mean(Q8v2part2) if _REGION_CAT == "West"
//Plot a twoway line graph
twoway (line midwest Northeast South West date), title("Region") name(Region, replace) 

graph combine Age Region

