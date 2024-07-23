***************************************************
* Project: Description of DAUPIN-Project

* Authors: Daniel Baron

* Employment dyads

* SOEP v38

******************

*** 

* Useful advices on how to automatically fill missings:

* https://www.stata.com/support/faqs/data-management/replacing-missing-values/

* 

* Optional program:

* fillmissing --> https://fintechprofessor.com/2019/12/20/fillmissing-fill-missing-values-in-stata/

***************************************************

clear

clear matrix

clear mata

putdocx clear

label drop _all

set more off

set maxvar 10000

***************************************************

* Set paths				/// Please customize paths and folders

global path_soep "..."

global path_soep_prep "..."

global path_out "..."				

global path_hdd "..."			

global tmp="..."					
																										
global tables="..."

global plots="..."

global putdocx="..."

***************************************************

*** Generate dataset (1)

use pid hid cid syear plh0032 plh0033 plh0036 plh0037 plh0042 plj0046 plg0033_h ///
pla0009_v2 pla0009_v3 pla0009_v4 /// Gender
plb0022_h plb0057_v4 plb0057_v5 plb0057_v6 plb0057_v7 plb0057_v9 plb0058 plb0064_v2 plb0064_v4 plb0065 ///
pld0131_v1 pld0131_v2 pld0131_v3 pld0140 plc0014_h ple0010_h pld0134 ///
plh0151 /// Life-satisfaction
ple0008 plh0171 /// Subjective health, satisfaction with health
pld0152 /// Child born
plb0037_h /// Befristung
plb0041_v1 /// Zeitarbeit 2001-2020
plb0041_v1 /// Zeitarbeit 2021
plc0057_h /// Kurzarbeitergeld erhalten (unvollstaendige Zeitreihe)
pli0038_h pli0043_h pli0044_h /// time used for: job/job training, housework, childcare (in hours, only Monday to Friday)
plb0362 /// Active job search before job change
plb0424_v1 plb0424_v2 /// active search for new job during the last 3 months / 4 weeks
pld0137 /// Start cohabitation
plh0303 plh0304 plh0305 plh0306 plh0307 plh0308_v1 plh0309 /// Gender role attitudes 2012 only, 4. cat
plh0300_v2 /// Gender role attitude 2018 only, 7 cat. : "You should get married if you live with your partner for a long time."
plh0302_v2 /// Gender role attitude 2018 only, 7 cat. : "Child younger than three years  suffers when mother works"
plh0308_v2 /// Gender role attitude 2018 only, 7 cat. : "It is best when men and women work equally and take care of the home, family and children."
plh0104 plh0105 plh0106 plh0107 plh0108 plh0109 plh0110 plh0110 plh0111 plh0112 /// Subjective relevance of life domains
equiv_inc_weight_l_in_1000e equiv_inc_gross_l_in_1000e equiv_inc_net_l_in_1000e /// Net equivalent income (in 1000 Euro)
equiv_inc_weight_l equiv_inc_gross_l equiv_inc_net_l /// Net equivalent income
pld0298_v3 /// Sexuelle Orientierung (Sample Q)
using "$path_soep_prep\pl_equivinc.dta" , clear

* Variable labels:

lab var equiv_inc_net_l_in_1000e "Actor's equivalized household net income (in 1,000 Euro)"

** Recodings

* Define variable labels

lab define worries_inv 0 "[0] No worries" 1 "[1] Some worries" 2 "[2] Many worries"

lab define worries_dich 0 "[0] No or some worries" 1 "[1] Many worries"

* Worried about general economic development (plh0032)

* Inverted (incl. renaming)

gen w_econ_gene=.

replace w_econ_gene=0 if plh0032==3

replace w_econ_gene=1 if plh0032==2

replace w_econ_gene=2 if plh0032==1

* Dichotomous

gen w_econ_gene_dich=.

replace w_econ_gene_dich=0 if w_econ_gene==0 | w_econ_gene==1

replace w_econ_gene_dich=1 if w_econ_gene==2

* Variable labels

lab var w_econ_gene "Worried about general economic development"

lab var w_econ_gene_dich "Worried about general economic development (dummy)"

* Value labels

lab val w_econ_gene worries_inv

lab val w_econ_gene_dich worries_dich

* Worried about private economic situation (plh0033)

* Inverted (incl. renaming)

gen w_econ_priv=.

replace w_econ_priv=0 if plh0033==3

replace w_econ_priv=1 if plh0033==2

replace w_econ_priv=2 if plh0033==1

* Dichotomous

gen w_econ_priv_dich=.

replace w_econ_priv_dich=0 if w_econ_priv==0 | w_econ_priv==1

replace w_econ_priv_dich=1 if w_econ_priv==2

* Variable labels

lab var w_econ_priv "Worried about private economic situation"

lab var w_econ_priv_dich "Worried about private economic situation (dummy)"

* Value labels

lab val w_econ_priv worries_inv

lab val w_econ_priv_dich worries_dich

* Worried about losing job (plh0042)

* Inverted (incl. renaming)

gen w_losing_job=.

replace w_losing_job=0 if plh0042==3

replace w_losing_job=1 if plh0042==2

replace w_losing_job=2 if plh0042==1

* Dichotomous

gen w_losing_job_dich=.

replace w_losing_job_dich=0 if w_losing_job==0 | w_losing_job==1

replace w_losing_job_dich=1 if w_losing_job==2

* Variable labels

lab var w_losing_job "Worried about losing job"

lab var w_losing_job_dich "Worried about losing job (dummy)"

* Value labels

lab val w_losing_job worries_inv

lab val w_losing_job_dich worries_dich

********

* Recode covariates

* Recode gender from pla0009_v2 (till 2019), pla0009_v3 (2020), and pla0009_v2 (2021); (0=male, 1=female)

gen gender=.

replace gender=0 if pla0009_v2==1 | pla0009_v3==1 | pla0009_v4==1

replace gender=1 if pla0009_v2==2 | pla0009_v3==2 | pla0009_v4==2

lab var gender "Gender"

lab def gender 0 "Male" 1 "Female"

lab val gender gender

tab gender

**********

* Recodings subjective relevance of life domains

sort pid syear

* Define value labels

lab def subj_rel 0 "Very unimportant" 1 "Unimportant" 2 "Important" 3 "Very important"

***

* Recodings

sort pid syear

* Subjective relevance: Be successful in your career

gen plh0107_rec=.

replace plh0107_rec=0 if plh0107==4

replace plh0107_rec=1 if plh0107==3

replace plh0107_rec=2 if plh0107==2

replace plh0107_rec=3 if plh0107==1

lab var plh0107_rec "Subjective relevance: Be successful in your career (4 cat.)"

lab val plh0107_rec subj_rel

** Fill intraindividual gaps with last valid measure before

gen plh0107_rec_panel=plh0107_rec

bysort pid: replace plh0107_rec_panel=plh0107_rec_panel[_n-1] if missing(plh0107_rec_panel)

lab var plh0107_rec_panel "Subjective relevance: Be successful in your career (4 cat., panel)"

lab val plh0107_rec_panel subj_rel

/*
* Time constant plh0107_rec

gen plh0107_rec_tc=plh0107_rec

bysort pid (syear): replace plh0107_rec_tc = plh0107_rec_tc[_n-1] if plh0107_rec_tc >= .

lab var plh0107_rec_tc "Subjective relevance: Be successful in your career (time const.)"

lab val plh0107_rec_tc subj_rel

bysort syear: tab plh0107_rec_tc
*/

**

* Subjective relevance: happy marriage or relationship

gen plh0109_rec=.

replace plh0109_rec=0 if plh0109==4

replace plh0109_rec=1 if plh0109==3

replace plh0109_rec=2 if plh0109==2

replace plh0109_rec=3 if plh0109==1

lab var plh0109_rec "Subjective relevance: Happy marriage or relationship (4 cat.)"

lab val plh0109_rec subj_rel

** Fill intraindividual gaps with last valid measure before

gen plh0109_rec_panel=plh0109_rec

bysort pid: replace plh0109_rec_panel=plh0109_rec_panel[_n-1] if missing(plh0109_rec_panel)

lab var plh0109_rec_panel "Subjective relevance: Happy marriage or relationship (4 cat., panel)"

lab val plh0109_rec_panel subj_rel

**

* Subjective relevance: having children (fertility intention)

gen plh0110_rec=.

replace plh0110_rec=0 if plh0110==4

replace plh0110_rec=1 if plh0110==3

replace plh0110_rec=2 if plh0110==2

replace plh0110_rec=3 if plh0110==1

lab var plh0110_rec "Subjective relevance: Having children (4 cat.)"

lab val plh0110_rec subj_rel

** Fill intraindividual gaps with last valid measure before

gen plh0110_rec_panel=plh0110_rec

bysort pid: replace plh0110_rec_panel=plh0110_rec_panel[_n-1] if missing(plh0110_rec_panel)

lab var plh0110_rec_panel "Subjective relevance: Having children (4 cat., panel)"

lab val plh0110_rec_panel subj_rel

*************************************************

* Preparing event variables: Marriage, child, divorce, job-loss

* Cohabitation event: pld0137

rename pld0137 cohab_event

replace cohab_event=0 if cohab_event==.

lab var cohab_event "Event: cohabitation (dummy)"

lab define cohab_event 0 "(0) No: not cohabitting" 1 "(1) Yes: cohabitting"

lab val cohab_event cohab_event

* Status Cohabitation - keep as 1 after event

gen cohab_status=cohab_event

bysort pid (syear): replace cohab_status = 1 if cohab_status[_n-1] == 1

lab var cohab_status "Status: cohabitation (dummy)"

lab define cohab_status 0 "(0) Not cohabitting" 1 "(1) Cohabitting"

lab val cohab_status child_born_status

**

* Birth of child

recode pld0152 (1=1) (-2=0), into(child_born_event)

lab var child_born_event "Event: Child born (dummy)"

lab def child_born_event 1 "(0) Child born: no" 0 "(1) Child born: yes"

lab val child_born_event child_born_event

* Status Birth of child - keep as 1 after event

sort pid syear

gen child_born_status=child_born

bysort pid (syear): replace child_born_status = 1 if child_born_status[_n-1] == 1

lab var child_born_status "Status: Child born (dummy)"

lab def child_born_status 0 "(0) No child born" 1 "(1) Child born"

lab val child_born_status child_born_status

**

* Divorce event: pld0140

rename pld0140 divorce_event

replace divorce_event=0 if divorce_event==.

lab var divorce_event "Event: Divorce, dissolution, or widowhood (dummy)"

lab def divorce_event 0 "(0) Divorce, dissolution, widowhood: no" 1 "(1) Divorce, dissolution, widowhood: yes"

lab val divorce_event divorce_event

* Marital status: divorced or eigentr. Lebenspartnerschaft dissolved or partner died (1) vs. other (0)

gen divorced_status=.

replace divorced_status=1 if pld0131_v1==2 | pld0131_v1==4 | pld0131_v1==5 | pld0131_v1==7

replace divorced_status=1 if pld0131_v2==4 | pld0131_v2==5

replace divorced_status=1 if pld0131_v3==4 | pld0131_v3==5 | pld0131_v3==6 | pld0131_v3==7

replace divorced_status=0 if pld0131_v1==1 | pld0131_v1==3 | pld0131_v1==6

replace divorced_status=0 if pld0131_v2==3 | pld0131_v2==6 | pld0131_v2==8

replace divorced_status=0 if pld0131_v3==1 | pld0131_v3==2 | pld0131_v3==3

bysort pid (syear): replace divorced_status = 1 if divorced_status[_n-1] == 1

lab var divorced_status "Status: Divorce, dissolution, or widowhood (dummy)"

lab define divorced_status 0 "(0) Not divorced etc." 1 "(1) Divorced, separated or widowed"

lab val divorced_status divorced_status

**

* Marriage event: pld0134

* Note: Construction of marriage-variables has been placed after those of divorce-variables to allow for correcting the married status-variable in case of divorce

rename pld0134 marriage_event

replace marriage_event=0 if marriage_event==.

lab var marriage_event "Event: marriage (dummy)"

lab define marriage_event 0 "(0) No: not married" 1 "(1) Yes: married"

lab val marriage_event marriage_event

* Family status: married or eingetragene Lebenspartnerschaft (1) vs. other (0)

gen married_status=.

replace married_status=1 if pld0131_v1==1 | pld0131_v1==6

replace married_status=1 if pld0131_v2==6 | pld0131_v2==8

replace married_status=1 if pld0131_v3==1 | pld0131_v3==2 

replace married_status=0 if pld0131_v1==2 | pld0131_v1== 3 | pld0131_v1==4 | pld0131_v1==5 | pld0131_v1==7

replace married_status=0 if pld0131_v2==3 | pld0131_v2==4 | pld0131_v2==5

replace married_status=0 if pld0131_v3==3 | pld0131_v3==4 | pld0131_v3==5 | pld0131_v3==6 | pld0131_v3==7

bysort pid (syear): replace married_status = 1 if married_status[_n-1] == 1

* Correct marriage-status in case of divorces (irrespective of numbers of marriages per person)

replace married_status=0 if divorced_status==1

lab var married_status "Status: marriage (dummy)"

lab define married_status 0 "(0) Not married" 1 "(1) Married"

lab val married_status married_status

******

* Labor market status:

gen labour_status=.

replace labour_status=1 if plb0022_h>=1 & plb0022_h<=8
replace labour_status=0 if plb0022_h==9

lab define labour_status 0 "Not employed" 1 "Employed"

lab val labour_status labour_status

* Job loss event

sort pid syear

gen jobloss_event=.

bysort pid: replace jobloss_event=1 if labour_status==0 & labour_status[_n-1]==1

replace jobloss_event=0 if jobloss_event==. & !missing(labour_status)

lab def jobloss_event 1 "Event: Not employed" 0 "No jobloss event"

lab val jobloss_event jobloss_event

***

* Labour force status

gen lab_force_status=.

replace lab_force_status=0 if plb0057_v4>=1 & plb0057_v4<=6
replace lab_force_status=0 if plb0057_v5>=1 & plb0057_v5<=3
replace lab_force_status=0 if plb0057_v6>=1 & plb0057_v6<=3
replace lab_force_status=0 if plb0057_v7>=1 & plb0057_v7<=3
replace lab_force_status=0 if plb0057_v9>=1 & plb0057_v9<=4
replace lab_force_status=1 if plb0065>=1 & plb0065<=4
replace lab_force_status=2 if plb0064_v2>=1 & plb0064_v2<=6
replace lab_force_status=2 if plb0064_v4>=1 & plb0064_v4<=7
replace lab_force_status=3 if plb0058>=1 & plb0058<=6
replace lab_force_status=4 if labour_status==0 

lab var lab_force_status "Labour Force Status"

lab define lab_force_status 0 "Self-employed" 1 "Civil servant" 2 "White-collar worker" 3 "Blue-collar worker" 4 "Not employed" 

lab val lab_force_status lab_force_status

* Labour force status (2011)

sort pid syear

gen lab_force_status_2011=.

replace lab_force_status_2011 = lab_force_status if syear==2011

bysort pid: replace lab_force_status_2011 = lab_force_status_2011[_n-1] if lab_force_status_2011 >= .

lab val lab_force_status_2011 lab_force_status

* Dummy variables Labour force status (1 = Blue-collar worker)

* Dummy: Labour force status, time-varying

gen lfs_dummy=.

replace lfs_dummy=1 if lab_force_status==3

replace lfs_dummy=0 if lab_force_status==0 | lab_force_status==1 | lab_force_status==2 | lab_force_status==4

lab def lfs_dummy 0 "Other" 1 "Blue-collar worker"

lab val lfs_dummy lfs_dummy

* Dummy: Labour force status, time-constant 2011

gen lfs2011_dummy=.

replace lfs2011_dummy=1 if lab_force_status_2011==3

replace lfs2011_dummy=0 if lab_force_status_2011==0 | lab_force_status_2011==1 | lab_force_status_2011==2 | lab_force_status_2011==4

lab val lfs2011_dummy lfs_dummy

* Generate income in 1,000 Euro

gen inc_1000=.

replace inc_1000=plc0014_h/1000

lab var inc_1000 "Personal net income per month (in 1,000 Euro)"

* Restrict inc_1000 to values >= 0

replace inc_1000=. if inc_1000<0

** Generate fixed-term dummy

gen fixed_term=.

replace fixed_term=1 if plb0037_h==2 
replace fixed_term=0 if plb0037_h==1

sort pid syear

* Fill gaps between two spells of fixed-term employment

bysort pid (syear): carryforward fixed_term, replace

* lab var fixed_term "Fixed-term employment (dummy)"

lab def fixed_term 0 "(0) Permanent employment" 1 "(1) Fixed-term employment"

lab val fixed_term fixed_term

* Generate Permanent contract-dummy

gen perm_empl=.

replace perm_empl=1 if fixed_term==0
replace perm_empl=0 if fixed_term==1

sort pid syear

* Fill gaps between two spells of permanent employment

* bysort pid (syear): carryforward perm_empl, replace

lab var perm_empl "Permanent employment (dummy)"

lab def perm_empl 0 "(0) Fixed-term employment" 1 "(1) Permanent employment"

lab val perm_empl perm_empl

****

** Generade employment indicator

gen empl_ind=.

replace empl_ind=0 if fixed_term==0
replace empl_ind=1 if fixed_term==1
replace empl_ind=2 if missing(fixed_term) & (plb0022_h==9 | plb0037_h==3)
replace empl_ind=3 if missing(fixed_term) & (plb0022_h==3 | plb0022_h==4 | plb0022_h==5 | plb0022_h==6 | plb0022_h==7 | ///
plb0022_h==8 | plb0022_h==10 | plb0022_h==11 | plb0022_h==12 | plb0037_h==4)

lab var empl_ind "Employment indicator (4 cat.)"

lab def empl_ind 0 "(0) Permanent employment" 1 "(1) Fixed-term employment" 2 "(2) Unemployed or inactive" 3 "(3) Other"

lab val empl_ind empl_ind

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward empl_ind, gen(empl_ind_carryf)

* Checking

tab empl_ind

tab fixed_term

sort pid syear

***



***

* Code missings

quietly mvdecode _all, mv(-1=.a \ -2=.b \ -3=.c \ -4=.d \ -5=.e \ -6=.f \ -7=.f \ -8=.h)

** Save generated dataset

save "${path_hdd}\pl_gen.dta" , replace

**************************************************************************************

*** Generate dataset (2)

use pid hid cid syear pgpartz /// Partner indicator
pgfamstd /// Family status
pgemplst /// Employment status (incl. geringfuegig beschaeftigt)
pglfs /// Labor force status
pgpsbil /// Level of education
pgisced11 /// Level of education (2011 ISCED)
pgpbbil01 pgpbbil02 pgpbbil03 /// Job training
pgbilzeit /// Duration of education (years)
pgerwzeit /// Duration of staff membership in company
pgoeffd /// Member of civil service
pgnace pgnace2 /// Sector
pgjobend /// Reason for termination
using "$path_soep\pgen", clear 

* Code missings

quietly mvdecode _all, mv(-1=.a \ -2=.b \ -3=.c \ -4=.d \ -5=.e \ -6=.f \ -7=.f \ -8=.h)

***

* Data preparation

** Partner indicator

gen partner_n=.

replace partner_n=1 if pgpartz>= 1 | pgpartz<=4
replace partner_n=0 if pgpartz== 0 | pgpartz==5

lab define partner_n 1 "Partner or spouse (probably)" 0 "No partner in household or unclear"

lab val partner_n partner_n

tab partner_n pgpartz

** Dummy Education 

gen pgpsbil_dich=.

replace pgpsbil_dich=1 if pgpsbil==4

replace pgpsbil_dich=0 if (pgpsbil>=1 & pgpsbil<=3) | (pgpsbil>=5 & pgpsbil<=8)

* Fill gaps

sort pid syear

bysort pid (syear): carryforward pgpsbil_dich, replace

lab def pgpsbil_d 1 "A-levels" 0 "Other or none"

lab val pgpsbil_dich pgpsbil_d

***

*** Factor variable job training

gen jobtrain = .

replace jobtrain = 0 if pgpbbil03 == 1 

replace jobtrain = 1 if pgpbbil01 == 1 | pgpbbil01==06

replace jobtrain = 2 if pgpbbil01 == 2 | pgpbbil01==3

replace jobtrain = 3 if pgpbbil01 == 4

replace jobtrain = 4 if pgpbbil01 == 5

replace jobtrain = 5 if pgpbbil02 >= 1 & pgpbbil02 <=10

lab var jobtrain "Professional qualification (6 cat.)"

lab def jobtrain 0 "(0) No qualification" 1 "(1) Vocational training or other" 2 "(2) Vocational college (incl. health sector)" ///
3 "(3) Technical college, foreman" 4 "(4) Training of civil servants" 5 "(5) University degree"

lab val jobtrain jobtrain

tab jobtrain

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward jobtrain, replace

tab jobtrain

*** Job training, dichotomized

* (1) Dummy: University degree = 1

gen jobtrain_uni = .

replace jobtrain_uni = 0 if jobtrain >= 0 & jobtrain <= 4

replace jobtrain_uni = 1 if jobtrain == 5

lab var jobtrain_uni "Professional qualification: University degree (dummy)"

lab def jobtrain_uni 0 "(0) No university degree" 1 "(1) University degree"

lab val jobtrain_uni jobtrain_uni

tab jobtrain_uni

* (2) Dummy: Qualification: yes = 1

gen jobtrain_qual = .

replace jobtrain_qual = 0 if jobtrain == 0

replace jobtrain_qual = 1 if jobtrain >= 1 & jobtrain <=5

lab var jobtrain_qual "Professional qualification obtained (dummy)"

lab def jobtrain_qual 0 "(0) No professional qualification obtained" 1 "(1) Professional qualification obtained"

lab val jobtrain_qual jobtrain_qual

tab jobtrain_qual

* (3) Dummy: Qualification: Non-academic

gen jobtrain_nonac = .

replace jobtrain_nonac = 0 if jobtrain == 0 | jobtrain == 5

replace jobtrain_nonac = 1 if jobtrain >= 1 & jobtrain <=4

lab var jobtrain_nonac "Professional qualification: non-academic (dummy)"

lab def jobtrain_nonac 0 "(0) University degree or no professional qualification" 1 "(1) Non-academic qualification"

lab val jobtrain_nonac jobtrain_nonac

tab jobtrain_nonac

* (4) Dummy: Qualification: no qualification

gen jobtrain_none = .

replace jobtrain_none = 0 if jobtrain_qual == 1

replace jobtrain_none = 1 if jobtrain_qual == 0

lab var jobtrain_none "Professional qualification: none (dummy)"

lab def jobtrain_none 0 "(0) Professional qualification obtained" 1 "(1) No professional qualification obtained"

lab val jobtrain_none jobtrain_none

tab jobtrain_none

***

* Dummy: parental leave

gen parental_leave=.

replace parental_leave = 1 if pglfs==4

replace parental_leave=0 if pglfs!=4 & !missing(pglfs)

lab var parental_leave "Parental leave (dummy)"

lab def parental_leave 0 "No" 1 "Yes"

lab val parental_leave parental_leave

fre parental_leave

***

*** Dummy 'Civil service'

gen pgoeffd_d=.

replace pgoeffd_d=1 if pgoeffd==1

replace pgoeffd_d=0 if pgoeffd==2

lab var pgoeffd_d "Actor: Working in civil service"

lab def pgoeffd_d 0 "No" 1 "Yes"

lab val pgoeffd_d pgoeffd_d


** Save generated dataset

save "${path_hdd}\pgen_gen.dta", replace

**************************************************************************************

* Generate dataset (3) - household

use hid syear hlc0043 /// number of children in household
using "$path_soep\hl", clear 

** Recode missings in hlc0043 (Child in household?) as 0 if hlc0043 = -2

replace hlc0043=0 if hlc0043==-2

* Recode hlc0043 (5 categories)

recode hlc0043 (0=0) (1=1) (2=2) (3=3) (4/12=4), into(hlc0043_rec)

lab var hlc0043_rec "No. of children in household (4 cat.)"

lab def hlc0043_rec 0 "0" 1 "1" 2 "2" 3 "3" 4 "4 or more"

lab val hlc0043_rec hlc0043_rec

* Code missings

quietly mvdecode _all, mv(-1=.a \ -2=.b \ -3=.c \ -4=.d \ -5=.e \ -6=.f \ -7=.f \ -8=.h)

** Save generated dataset

save "${path_hdd}\hl_gen.dta", replace

**************************************************************************************

* Generate dataset (4) - biohob

use pid bioyear einstieg_pbio einstieg_artk /// year of first job
using "$path_soep\biojob", clear 

replace einstieg_artk=. if einstieg_artk==-2

replace einstieg_pbio=. if einstieg_pbio==-2

rename bioyear syear

save "${path_hdd}\biojob_gen.dta", replace

**************************************************************************************

* Generate dataset (5) - pequiv

use pid syear l11101 ///
d11109 /// Numbers of years of education
e11102 e11103 e11104 /// Employment status, employment level, primary labor activity
e11105_v1 e11105_v2 e11106 e11107 /// occupation and industry
using "$path_soep\pequiv", clear

* Variable erstellen Ost-Westdeutschland

gen eastwest=.

replace eastwest=1 if l11101==11 | l11101==12 | l11101==13 | l11101==14 | l11101==15 | l11101==16

replace eastwest=0 if l11101==1 | l11101==2 | l11101==3 | l11101==4 | l11101==5 | l11101==6 | ///
l11101==7 | l11101==8 | l11101==9 | l11101==10

lab var eastwest "Place of living: East or West Germany"

lab define eastwest 1 "East Germany (1)" 0 "West Germany (0)"

lab val eastwest eastwest

save "${path_hdd}\pequiv_gen.dta", replace

**************************************************************************************

* Merge

use "$path_soep\ppathl.dta", clear

* Code missings

quietly mvdecode _all, mv(-1=.a \ -2=.b \ -3=.c \ -4=.d \ -5=.e \ -6=.f \ -7=.f \ -8=.h)

* Merge

merge 1:1 pid syear using "${path_hdd}\pgen_gen.dta", nogen

merge 1:1 pid syear using "${path_hdd}\pl_gen.dta", nogen

merge m:1 hid syear using "${path_hdd}\hl_gen.dta" , nogen

merge 1:1 pid syear using "${path_hdd}\biojob_gen.dta" , nogen

merge 1:1 pid syear using "${path_hdd}\pequiv_gen.dta" , nogen

*****

* Drop if hid or pid is missing:

drop if missing(hid)

drop if missing(pid)

* Recode missing pld0298_v3, sexor

replace pld0298_v3=. if pld0298_v3>3

replace sexor=. if sexor>1

*****

** Generate age variable

sort pid syear

gen age=syear-gebjahr

lab var age "Actor's age (years)"

***

* Restrict sample to persons at working-age

drop if age<14 & !missing(age)

drop if age>67 & !missing(age)

***

** Age-dummies

gen age16_25=0 if !missing(age)

replace age16_25=1 if age>=16 & age<26

gen age26_30=0 if !missing(age)

replace age26_30=1 if age>=26 & age<31

gen age31_35=0 if !missing(age)

replace age31_35=1 if age>=31 & age<36

gen age36_40=0 if !missing(age)

replace age36_40=1 if age>=36 & age<41

gen age41_45=0 if !missing(age)

replace age41_45=1 if age>=41 & age<46

gen age46_50=0 if !missing(age)

replace age46_50=1 if age>=46 & age<51

gen age51_55=0 if !missing(age)

replace age51_55=1 if age>=51 & age<56

gen age56_60=0 if !missing(age)

replace age56_60=1 if age>=56 & age<61

gen age61_67=0 if !missing(age)

replace age61_67=1 if age>=61 & age<67

* Sort variables

sort pid syear

move age syear

***

* Generare one measure for entry into labor market

sort pid syear

gen lab_entry = einstieg_pbio

replace lab_entry = einstieg_artk if missing(lab_entry)

* Generate time-constant measure for entry into labor market

gen lab_entry_tc=lab_entry

bysort pid (syear): carryforward lab_entry_tc, replace

tab lab_entry_tc

***

* Generate measure for time since entry into labor market:

sort pid syear

gen time_lab_entry = syear-lab_entry_tc

replace time_lab_entry=. if time_lab_entry<0

tab time_lab_entry

lab var time_lab_entry "Time since actor's labour market entry (years)"

* Set to missing implausible values for time since labour market-entry

replace time_lab_entry=. if time_lab_entry>53

*************

* Dummy: Children in household?

gen child_in_hh = .

replace child_in_hh = 0 if hlc0043_rec== 0
replace child_in_hh = 1 if hlc0043_rec>0 & hlc0043_rec<5

lab var child_in_hh "Children in household (dummy)"

lab def child_in_hh 0 "(0) No child in household" 1 "(1) Yes, at least one child in household"

lab val child_in_hh child_in_hh

tab child_in_hh

**************************************************

* Prepare dependent variables for survival analyses

sort pid syear

* Dependent variables

* (1) Permanent employment (reference: Fixed-term employment, jobless, unemployed, other)

* Note: Permanent contract-dummy with larger control group:

gen perm_empl_enh_perm = .

replace perm_empl_enh_perm = 1 if perm_empl == 1 & ///
!missing(perm_empl, plb0022_h, pglfs)

replace perm_empl_enh_perm = 0 if (perm_empl==0 | plb0022_h==4 | plb0022_h==7 | plb0022_h==8 | plb0022_h==10 | plb0022_h==12 | plb0022_h==9 | pglfs==6) & ///
missing(perm_empl_enh_perm)

lab var perm_empl_enh_perm "Permanent employment (dummy)"

lab def perm_empl_enh_perm 0 "(0) Fixed-term, other emplyoment, jobless, or unemployed" 1 "(1) Permanent employment"

lab val perm_empl_enh_perm perm_empl_enh_perm

tab perm_empl_enh_perm

tab perm_empl

tab perm_empl_enh_perm perm_empl

***

* (2) Jobless

gen perm_empl_enh_jobl = .

replace perm_empl_enh_jobl = 1 if (plb0022_h==9) & ///
!missing(perm_empl, plb0022_h, pglfs)

replace perm_empl_enh_jobl = 0 if (perm_empl==1 | perm_empl==0 | plb0022_h==4 | plb0022_h==7 | plb0022_h==8 | plb0022_h==10 | plb0022_h==12 | pglfs==6) & ///
missing(perm_empl_enh_jobl)

lab var perm_empl_enh_jobl "Jobless (dummy)"

lab def perm_empl_enh_jobl 0 "(0) Permanent, fixed-term, other employment, or unemployed" 1 "(1) Jobless"

lab val perm_empl_enh_jobl perm_empl_enh_jobl

***

* (3) Unemployed

gen perm_empl_enh_unemp = .

replace perm_empl_enh_unemp = 1 if pglfs==6 & !missing(perm_empl, plb0022_h, pglfs)

replace perm_empl_enh_unemp = 0 if (perm_empl==1 | perm_empl==0 | plb0022_h==9 | plb0022_h==4 | plb0022_h==7 | plb0022_h==8 | plb0022_h==10 | plb0022_h==12) & ///
missing(perm_empl_enh_unemp)

lab var perm_empl_enh_unemp "Unemployed (dummy)"

lab def perm_empl_enh_unemp 0 "(0) Permanent, fixed-term, other employment, or jobless" 1 "(1) Unemployed"

lab val perm_empl_enh_unemp perm_empl_enh_unemp

***

* (4) Other employment

gen perm_empl_enh_other = .

replace perm_empl_enh_other = 1 if (plb0022_h==4 | plb0022_h==7 | plb0022_h==8 | plb0022_h==10 | plb0022_h==12) & ///
!missing(perm_empl, plb0022_h, pglfs)

replace perm_empl_enh_other = 0 if (perm_empl==1 | perm_empl==0 | plb0022_h==9 | pglfs==6) & ///
missing(perm_empl_enh_other)

lab var perm_empl_enh_other "Other employment (dummy)"

lab def perm_empl_enh_other 0 "(0) Permanent, fixed-term emplyoment, jobless, unemployed" 1 "(1) Other employment"

lab val perm_empl_enh_other perm_empl_enh_other

***

* (5) Fixed-term employment

gen perm_empl_enh_fte = .

replace perm_empl_enh_fte = 1 if perm_empl==0 & ///
!missing(perm_empl, plb0022_h, pglfs)

replace perm_empl_enh_fte = 0 if (perm_empl==1 | plb0022_h==4 | plb0022_h==7 | plb0022_h==8 | plb0022_h==10 | plb0022_h==12 | plb0022_h==9) ///
& missing(perm_empl_enh_fte)

lab var perm_empl_enh_fte "Fixed-term employment (dummy)"

lab def perm_empl_enh_fte 0 "(0) Permanent, other emplyoment, jobless, or unemployed" 1 "(1) Fixed-term employment"

lab val perm_empl_enh_fte perm_empl_enh_fte

***

* Frequencies (episodes)

fre perm_empl_enh_perm perm_empl_enh_jobl perm_empl_enh_unemp perm_empl_enh_other perm_empl_enh_fte

***********************************

* Create dyad-id

sort hid pid syear

egen a=group(hid pid parid)
egen b=group(hid parid pid)

* list syear a b pid parid hid if hid<5000, sepby(hid)

egen c=rowmin(a b)

* list syear a b c pid parid hid if hid<5000, sepby(hid)

* Generate dyad-id

egen dyad=group(hid c)

lab var dyad "Dyad ID"

sort hid syear

* list syear a b c dyad pid parid hid if hid<5000, sepby(dyad)

*****

* Create dyad indicator

gen dyad_ind=.

replace dyad_ind=1 if !missing(dyad)

replace dyad_ind=0 if missing(dyad_ind)

lab var dyad_ind "Dyad Indicator"

* Check

sort dyad pid syear

* list syear dyad_ind pid parid hid if hid<10000, sepby(dyad)

***

* Drop non-dyads

drop if missing(dyad)

***

* Create indicator for Actor 1 and Actor 2 in dyads

gen dyad_nr=.

bysort dyad syear (pid): replace dyad_nr=_n

* tab dyad_nr

***

* Create indicator for partner's fixed-term employment (fixed_term_partner)

sort dyad syear pid

gen fixed_term_partner=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace fixed_term_partner=fixed_term[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad fixed_term fixed_term_partner pid hid if hid<100, sepby(hid)

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace fixed_term_partner=fixed_term[_n-1] if !missing(fixed_term) & missing(fixed_term_partner)

lab val fixed_term_partner fixed_term

** Fill gaps between to episodes of the same kind

sort pid syear

* bysort pid (syear): carryforward fixed_term_partner, replace

lab var fixed_term_partner "Partners' Fixed-term employment (dummy)"

lab val fixed_term_partner fixed_term

* Checking

sort dyad syear pid

* list syear dyad fixed_term fixed_term_partner pid hid if hid<100, sepby(hid)

**

* Generate Permanent contract-dummy - partner

sort dyad syear pid

gen perm_empl_partner=.

* Fill perm_empl_partner with value from actor

bysort dyad syear: replace perm_empl_partner=perm_empl[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad perm_empl perm_empl_partner pid hid if hid<100, sepby(hid)

* Fill perm_empl_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace perm_empl_partner=perm_empl[_n-1] if !missing(perm_empl) & missing(perm_empl_partner)

** Fill gaps between to episodes of the same kind

sort pid syear

* bysort pid (syear): carryforward perm_empl_partner, replace

lab var perm_empl_partner "Partners' Permanent employment (dummy)"

lab val perm_empl_partner perm_empl

* Checking

sort pid syear

* list pid syear perm_empl_partner if pid<1150, sepby(pid)

**

* Generate Permanent contract-dummy, enhanced control group - partner

sort dyad syear pid

gen perm_empl_enh_partner=.

* Fill perm_empl_partner with value from actor

bysort dyad syear: replace perm_empl_enh_partner=perm_empl_enh_perm[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad perm_empl_enh_perm perm_empl_enh_partner pid hid if hid<100, sepby(hid)

* Fill perm_empl_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace perm_empl_enh_partner=perm_empl_enh_perm[_n-1] if !missing(perm_empl_enh_perm) & missing(perm_empl_enh_partner)

lab var perm_empl_enh_partner "Partners' Permanent employment - enhanced control group (dummy)"

lab val perm_empl_enh_partner perm_empl

*****

* Create indicator for partner's type of employment (empl_ind_partner)

sort dyad syear pid

gen empl_ind_partner=.

* Fill empl_ind_partner with value from actor

bysort dyad syear: replace empl_ind_partner=empl_ind[_n-1]

* Checking

sort dyad syear pid

* list syear dyad fixed_term empl_ind_partner pid hid if hid<100, sepby(hid)

* Fill empl_ind_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace empl_ind_partner=empl_ind[_n-1] if !missing(empl_ind) & missing(empl_ind_partner)

lab val empl_ind_partner empl_ind

* Checking

sort dyad syear pid

* list syear dyad empl_ind empl_ind_partner pid hid if hid<150, sepby(hid)

*** Dummyies: Partners' type of employment employment

* Dummy: Partners' employment: Permanent employment (Reference: Fixed-term emplyoment, unemployed, jobless, other)

gen empl_partn_perm = .

replace empl_partn_perm = 0 if empl_ind_partner == 1 | empl_ind_partner == 2 | empl_ind_partner == 3

replace empl_partn_perm = 1 if empl_ind_partner == 0

lab var empl_partn_perm "Partners' type of emplyoment: permanent employment (dummy)"

lab def empl_partn_perm 0 "(0) Fixed-term employment, unemployed or jobless, other" 1 "(1) Permanent employment"

lab val empl_partn_perm empl_partn_perm

* Dummy: Partners' employment: Fixed-term-employment (Reference: Permanent emplyoment, unemployed, jobless, other)

gen empl_partn_fte = .

replace empl_partn_fte = 0 if empl_ind_partner == 0 | empl_ind_partner == 2 | empl_ind_partner == 3

replace empl_partn_fte = 1 if empl_ind_partner == 1

lab var empl_partn_fte "Partners' type of emplyoment: fixed-term employment (dummy)"

lab def empl_partn_fte 0 "(0) Permanent employment, unemployed jobless, other" 1 "(1) Fixed-term employment"

lab val empl_partn_fte empl_partn_fte

* Dummy: Partners' employment: Unemployed, jobless or other (Reference: Permanent emplyoment)

gen empl_partn_unempjl = .

replace empl_partn_unempjl = 0 if empl_ind_partner == 0 | empl_ind_partner ==  1

replace empl_partn_unempjl = 1 if empl_ind_partner == 2 | empl_ind_partner == 3

lab var empl_partn_unempjl "Partners' type of emplyoment: unemployed or jobless (dummy)"

lab def empl_partn_unempjl 0 "(0) Permanent employment, fixed-term employment" 1 "(1) Unemployed, jobless, or other"

lab val empl_partn_unempjl empl_partn_unempjl

* Check: 

fre empl_partn_perm

fre empl_partn_fte

fre empl_partn_unempjl

*****

* Person-specific indicator for employment constellation in dyad

gen empl_const_pers=.

replace empl_const_pers=0 if empl_ind==0 & empl_ind_partner==0

replace empl_const_pers=1 if (empl_ind==1 & empl_ind_partner==1)

replace empl_const_pers=2 if (empl_ind==2 & empl_ind_partner==2)

replace empl_const_pers=3 if (empl_ind==3 & empl_ind_partner==3)

replace empl_const_pers=4 if (empl_ind==1 & empl_ind_partner==0) | (empl_ind==0 & empl_ind_partner==1)

replace empl_const_pers=5 if (empl_ind==0 & empl_ind_partner==2) | (empl_ind==2 & empl_ind_partner==0)

replace empl_const_pers=6 if (empl_ind==1 & empl_ind_partner==2) | (empl_ind==2 & empl_ind_partner==1)

replace empl_const_pers=7 if (empl_ind==0 & empl_ind_partner==3) | (empl_ind==3 & empl_ind_partner==0)

replace empl_const_pers=8 if (empl_ind==1 & empl_ind_partner==3) | (empl_ind==3 & empl_ind_partner==1)

replace empl_const_pers=9 if (empl_ind==2 & empl_ind_partner==3) | (empl_ind==3 & empl_ind_partner==2)

lab var empl_const_pers "Employment constellation in partnership (person-specific, 10 cat.)"

lab define empl_const ///
0 "(0) Actor, Partner: Permanent contract" ///
1 "(1) A, P: Fixed-term" ///
2 "(2) A, P: Unemployed or jobless" ///
3 "(3) A, P: other" ///
4 "(4) A: Permanent, P: Fixed-term (v.v.)" ///
5 "(5) A: Permanent, P: Unemployed or jobless (v.v.)" ///
6 "(6) A: Fixed-term, P: Unemployed or jobless (v.v.)" ///
7 "(7) A: Other, P: Permanent (v.v.)" ///
8 "(8) A: Other, P: Fixed-term (v.v.)" ///
9 "(9) A: Other, P: Unemployed or jobless (v.v.)"

lab val empl_const_pers empl_const

* Checking

tab empl_const_pers

* list syear empl_ind empl_ind_partner empl_const_pers pid if hid<150, sepby(hid)

* list syear dyad empl_ind empl_ind_partner empl_const_pers pid if hid<150, sepby(hid) nolab

* Dyad-specific indicator for employment constellation in dyad

sort dyad syear pid

gen empl_const_dyad=.

replace empl_const_dyad=empl_const_pers if dyad_nr==1

lab var empl_const_dyad "Employment constellation in partnership (Dyad-specific, 10 cat.)"

lab val empl_const_dyad empl_const

* Checking
/*
tab empl_const_dyad

tab empl_const_pers
*/
***************************************

* Create indicator for actor's sexual orientation (sexor_actor)

gen sexor_actor=sexor

*****

* Create indicator for partner's sexual orientation (sexor_partner)

sort dyad syear pid

gen sexor_partner=.

* Fill sexor_partner with value from actor

bysort dyad syear: replace sexor_partner=sexor_actor[_n-1]

* Checking

sort dyad syear pid

* list syear dyad sexor_actor sexor_partner pid hid if hid<100, sepby(hid)

* Fill sexor_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace sexor_partner=sexor_actor[_n-1] if !missing(sexor_actor) & missing(sexor_partner)

* lab def sexor 0 "Probably heterosexual" 1 "Probably bi-/homosexual"

lab val sexor_partner sexor_actor

* Checking

sort dyad syear pid

* list syear dyad sexor_actor sexor_partner pid hid if hid<150, sepby(hid)

*****

* Person-specific indicator for constellation of sexual orientations in dyad

gen sexor_dyad=.

replace sexor_dyad=0 if sexor_actor==0 & sexor_partner==0

replace sexor_dyad=1 if (sexor_actor==1 & sexor_partner==0) | (sexor_actor==0 & sexor_partner==1)

replace sexor_dyad=2 if (sexor_actor==1 & sexor_partner==1)

lab var sexor_dyad "Factor: Constellation of sexual orientations in dyad"

lab define sexor_dyad 0 "Actor, Partner: hetero" 1 "A: hetero, P: bi/homo (or v.v.)" 2 "A, P: bi/homo"

lab val sexor_dyad sexor_dyad

* Dichotomous person-specific indicator for constellation of sexual orientations in dyad-episodes

gen sexor_dyad_dich=.

replace sexor_dyad_dich=0 if sexor_dyad==0

replace sexor_dyad_dich=1 if sexor_dyad==1 | sexor_dyad==2

lab var sexor_dyad_dich "Constellation of sexual orientations in dyad (person-specific, dummy)"

lab def sexor_dyad_dich 0 "(0) Actor, Partner: hetero" 1 "(1) At least one bi- or homosexual"

lab val sexor_dyad_dich sexor_dyad_dich

* Dichotomous dyad-specific indicator for constellation of sexual orientations in dyad-episodes

gen sexor_dyad_dich_dy = sexor_dyad_dich if dyad_nr==1

lab var sexor_dyad_dich_dy "Constellation of sexual orientations in dyad (dyad-specific, dummy)"

lab val sexor_dyad_dich_dy sexor_dyad_dich

*******************************************************

* Preparing measures for Gender role attitudes: plh0300_v2, plh0302_v2, plh0308_v2 [GRA 2018], plh0308_v1 [GRA 2012]

lab def gra2018_rec 0 "(0) Completely disagree" 1 "(1) Scale 1-7" 2 "(2) Scale 1-7" 3 "(3) Scale 1-7" ///
4 "(4) Scale 1-7" 5 "(5) Scale 1-7" 6 "(6) Completely agree"

lab def gra_tc_const_pers 0 "(0) A, P: traditional" 1 "(1) A, P: moderate" 2 "(2) A, P: egalitarian" ///
3 "(3) A: traditional, P: moderate (v.v.)" 4 "(4) A: moderate, P: egalitarian (v.v.)" ///
5 "(5) A: egalitarian, P: traditional (v.v.)"

***

* (1) plh0300_v2: You should get married if you live with your partner for a long time

* Recode plh0300_v2 to 0-6 (instead of 1-7)

recode plh0300_v2 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1) (7=6), into(plh0300_v2_rec)

lab val plh0300_v2_rec gra2018_rec

lab var plh0300_v2_rec "Actor, GRA 1: You should get married if you live with your partner for a long time"

* Generate plh0300_v2 [GRA 2018] as a time-constant covariate 

gen plh0300_v2_rec_tc=plh0300_v2_rec

bysort pid (syear): replace plh0300_v2_rec_tc = plh0300_v2_rec_tc[_n-1] if plh0300_v2_rec_tc >= .

lab var plh0300_v2_rec_tc "Actor, GRA 1: You should get married if you live with your partner for a long time (time-constant)"

lab val plh0300_v2_rec_tc gra2018_rec

sort dyad pid syear

* Interaction: plh0300_v2_rec_tc*gender

gen plh0300_v2_gender=plh0300_v2_rec_tc*gender

***

* Create indicator for partner's GRA item 1 (gra_tc_partner)

sort dyad syear pid

gen plh0300_v2_rec_tc_p=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace plh0300_v2_rec_tc_p=plh0300_v2_rec_tc[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad gra_tc gra_tc_partner pid hid if hid<100, sepby(hid)

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace plh0300_v2_rec_tc_p=plh0300_v2_rec_tc[_n-1] if !missing(plh0300_v2_rec_tc) & missing(plh0300_v2_rec_tc_p)

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward plh0300_v2_rec_tc_p, replace

lab var plh0300_v2_rec_tc_p "Partner, GRA 1: You should get married if you live with your partner for a long time"

lab val plh0300_v2_rec_tc_p plh0300_v2_rec

* Checking

* sort dyad pid syear

* list syear dyad pid gra_tc gra_tc_partner hid if dyad<36000 & dyad>34000, sepby(hid)

*****

* Person-specific indicator for constellations of plh0300_v2_rec_tc (GRA Item 3) in dyad

gen plh0300_v2_const_dyad=.

* 0 = Actor & partner: traditional

replace plh0300_v2_const_dyad=0 if plh0300_v2_rec_tc==0 & plh0300_v2_rec_tc_p==0

replace plh0300_v2_const_dyad=0 if plh0300_v2_rec_tc==0 & plh0300_v2_rec_tc_p==1

replace plh0300_v2_const_dyad=0 if plh0300_v2_rec_tc==1 & plh0300_v2_rec_tc_p==0

replace plh0300_v2_const_dyad=0 if plh0300_v2_rec_tc==1 & plh0300_v2_rec_tc_p==1

* 1 = Actor & partner: moderate

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==3

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==4

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==3 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==3 & plh0300_v2_rec_tc_p==3

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==3 & plh0300_v2_rec_tc_p==4

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==4 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==4 & plh0300_v2_rec_tc_p==3

replace plh0300_v2_const_dyad=1 if plh0300_v2_rec_tc==4 & plh0300_v2_rec_tc_p==4

* 2 = Actor & partner: egalitarian

replace plh0300_v2_const_dyad=2 if plh0300_v2_rec_tc==5 & plh0300_v2_rec_tc_p==5

replace plh0300_v2_const_dyad=2 if plh0300_v2_rec_tc==5 & plh0300_v2_rec_tc_p==6

replace plh0300_v2_const_dyad=2 if plh0300_v2_rec_tc==6 & plh0300_v2_rec_tc_p==5

replace plh0300_v2_const_dyad=2 if plh0300_v2_rec_tc==6 & plh0300_v2_rec_tc_p==6

* 3 = Actor: traditional, partner: moderate (v.v.)

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==0 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==0 & plh0300_v2_rec_tc_p==3

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==0 & plh0300_v2_rec_tc_p==4

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==1 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==1 & plh0300_v2_rec_tc_p==3

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==1 & plh0300_v2_rec_tc_p==4

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==0

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==3 & plh0300_v2_rec_tc_p==0

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==4 & plh0300_v2_rec_tc_p==0

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==1

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==3 & plh0300_v2_rec_tc_p==1

replace plh0300_v2_const_dyad=3 if plh0300_v2_rec_tc==4 & plh0300_v2_rec_tc_p==1

* 4 = Actor: moderate, partner: egalitarian (v.v.)

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==5

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==6

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==3 & plh0300_v2_rec_tc_p==5

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==3 & plh0300_v2_rec_tc_p==6

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==4 & plh0300_v2_rec_tc_p==5

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==4 & plh0300_v2_rec_tc_p==6

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==5 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==6 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==5 & plh0300_v2_rec_tc_p==3

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==6 & plh0300_v2_rec_tc_p==3

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==5 & plh0300_v2_rec_tc_p==4

replace plh0300_v2_const_dyad=4 if plh0300_v2_rec_tc==6 & plh0300_v2_rec_tc_p==4

* 5 = Actor: egalitarian, partner: traditional (v.v.)

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==5 & plh0300_v2_rec_tc_p==0

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==5 & plh0300_v2_rec_tc_p==1

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==5 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==6 & plh0300_v2_rec_tc_p==0

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==6 & plh0300_v2_rec_tc_p==1

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==6 & plh0300_v2_rec_tc_p==2

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==0 & plh0300_v2_rec_tc_p==5

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==1 & plh0300_v2_rec_tc_p==5

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==5

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==0 & plh0300_v2_rec_tc_p==6

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==1 & plh0300_v2_rec_tc_p==6

replace plh0300_v2_const_dyad=5 if plh0300_v2_rec_tc==2 & plh0300_v2_rec_tc_p==6

lab var plh0300_v2_const_dyad "Constellation of gender role attitudes in dyads (item 1)"

lab val plh0300_v2_const_dyad gra_tc_const_pers

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward plh0300_v2_const_dyad, replace

***

* (2) plh0302_v2: Child younger than three years  suffers when mother works

* Recode plh0302_v2 to 0-6 (instead of 1-7)

recode plh0302_v2 (1=6) (2=5) (3=4) (4=3) (5=2) (6=1) (7=6), into(plh0302_v2_rec)

lab val plh0302_v2_rec gra2018_rec

lab var plh0302_v2_rec "Actor, GRA 2: Child younger than three years  suffers when mother works"

* Generate plh0302_v2 [GRA 2018] as a time-constant covariate 

gen plh0302_v2_rec_tc=plh0302_v2_rec

bysort pid (syear): replace plh0302_v2_rec_tc = plh0302_v2_rec_tc[_n-1] if plh0302_v2_rec_tc >= .

lab var plh0302_v2_rec_tc "Actor, GRA 2: Child younger than three years  suffers when mother works (time-constant)"

lab val plh0302_v2_rec_tc gra2018_rec

sort dyad pid syear

* Interaction: plh0302_v2_rec_tc*gender

gen plh0302_x_gender=plh0302_v2_rec_tc*gender

***

* Create indicator for partner's GRA item 1 (gra_tc_partner)

sort dyad syear pid

gen plh0302_v2_rec_tc_p=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace plh0302_v2_rec_tc_p=plh0302_v2_rec_tc[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad gra_tc gra_tc_partner pid hid if hid<100, sepby(hid)

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace plh0302_v2_rec_tc_p=plh0302_v2_rec_tc[_n-1] if !missing(plh0302_v2_rec_tc) & missing(plh0302_v2_rec_tc_p)

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward plh0302_v2_rec_tc_p, replace

lab var plh0302_v2_rec_tc_p "Partner, GRA 2: Child younger than three years  suffers when mother works"

lab val plh0302_v2_rec_tc_p plh0302_v2_rec

* Checking

* sort dyad pid syear

* list syear dyad pid gra_tc gra_tc_partner hid if dyad<36000 & dyad>34000, sepby(hid)

*****

* Person-specific indicator for constellations of plh0302_v2_rec_tc (GRA Item 3) in dyad

gen plh0302_v2_const_dyad=.

* 0 = Actor & partner: traditional

replace plh0302_v2_const_dyad=0 if plh0302_v2_rec_tc==0 & plh0302_v2_rec_tc_p==0

replace plh0302_v2_const_dyad=0 if plh0302_v2_rec_tc==0 & plh0302_v2_rec_tc_p==1

replace plh0302_v2_const_dyad=0 if plh0302_v2_rec_tc==1 & plh0302_v2_rec_tc_p==0

replace plh0302_v2_const_dyad=0 if plh0302_v2_rec_tc==1 & plh0302_v2_rec_tc_p==1

* 1 = Actor & partner: moderate

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==3

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==4

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==3 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==3 & plh0302_v2_rec_tc_p==3

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==3 & plh0302_v2_rec_tc_p==4

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==4 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==4 & plh0302_v2_rec_tc_p==3

replace plh0302_v2_const_dyad=1 if plh0302_v2_rec_tc==4 & plh0302_v2_rec_tc_p==4

* 2 = Actor & partner: egalitarian

replace plh0302_v2_const_dyad=2 if plh0302_v2_rec_tc==5 & plh0302_v2_rec_tc_p==5

replace plh0302_v2_const_dyad=2 if plh0302_v2_rec_tc==5 & plh0302_v2_rec_tc_p==6

replace plh0302_v2_const_dyad=2 if plh0302_v2_rec_tc==6 & plh0302_v2_rec_tc_p==5

replace plh0302_v2_const_dyad=2 if plh0302_v2_rec_tc==6 & plh0302_v2_rec_tc_p==6

* 3 = Actor: traditional, partner: moderate (v.v.)

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==0 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==0 & plh0302_v2_rec_tc_p==3

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==0 & plh0302_v2_rec_tc_p==4

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==1 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==1 & plh0302_v2_rec_tc_p==3

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==1 & plh0302_v2_rec_tc_p==4

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==0

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==3 & plh0302_v2_rec_tc_p==0

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==4 & plh0302_v2_rec_tc_p==0

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==1

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==3 & plh0302_v2_rec_tc_p==1

replace plh0302_v2_const_dyad=3 if plh0302_v2_rec_tc==4 & plh0302_v2_rec_tc_p==1

* 4 = Actor: moderate, partner: egalitarian (v.v.)

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==5

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==6

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==3 & plh0302_v2_rec_tc_p==5

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==3 & plh0302_v2_rec_tc_p==6

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==4 & plh0302_v2_rec_tc_p==5

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==4 & plh0302_v2_rec_tc_p==6

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==5 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==6 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==5 & plh0302_v2_rec_tc_p==3

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==6 & plh0302_v2_rec_tc_p==3

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==5 & plh0302_v2_rec_tc_p==4

replace plh0302_v2_const_dyad=4 if plh0302_v2_rec_tc==6 & plh0302_v2_rec_tc_p==4

* 5 = Actor: egalitarian, partner: traditional (v.v.)

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==5 & plh0302_v2_rec_tc_p==0

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==5 & plh0302_v2_rec_tc_p==1

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==5 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==6 & plh0302_v2_rec_tc_p==0

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==6 & plh0302_v2_rec_tc_p==1

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==6 & plh0302_v2_rec_tc_p==2

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==0 & plh0302_v2_rec_tc_p==5

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==1 & plh0302_v2_rec_tc_p==5

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==5

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==0 & plh0302_v2_rec_tc_p==6

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==1 & plh0302_v2_rec_tc_p==6

replace plh0302_v2_const_dyad=5 if plh0302_v2_rec_tc==2 & plh0302_v2_rec_tc_p==6

lab var plh0302_v2_const_dyad "Constellation of gender role attitudes in dyads (item 2)"

lab val plh0302_v2_const_dyad gra_tc_const_pers

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward plh0302_v2_const_dyad, replace

***

* (3) plh0308_v2: It is best when men and women work equally and take care of the home, family and children

* Recode plh0308_v2 to 0-6 (instead of 1-7)

recode plh0308_v2 (1=0 ) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6), into(plh0308_v2_rec)

lab val plh0308_v2_rec gra2018_rec

lab var plh0308_v2_rec "Actor, GRA 3: It is best when men and women work equally and take care of the home, family and children"

* Generate plh0308_v2 [GRA 2018] as a time-constant covariate 

gen plh0308_v2_rec_tc=plh0308_v2_rec

bysort pid (syear): replace plh0308_v2_rec_tc = plh0308_v2_rec_tc[_n-1] if plh0308_v2_rec_tc >= .

lab var plh0308_v2_rec_tc "Actor, GRA 3: It is best when men and women work equally and take care of the home, family and children (time-constant)"

lab val plh0308_v2_rec_tc gra2018_rec

sort dyad pid syear

* Interaction: plh0308_v2_rec_tc*gender

gen plh0308_x_gender=plh0308_v2_rec_tc*gender

***

* Create indicator for partner's GRA item 1 (gra_tc_partner)

sort dyad syear pid

gen plh0308_v2_rec_tc_p=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace plh0308_v2_rec_tc_p=plh0308_v2_rec_tc[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad gra_tc gra_tc_partner pid hid if hid<100, sepby(hid)

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace plh0308_v2_rec_tc_p=plh0308_v2_rec_tc[_n-1] if !missing(plh0308_v2_rec_tc) & missing(plh0308_v2_rec_tc_p)

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward plh0308_v2_rec_tc_p, replace

lab var plh0308_v2_rec_tc_p "Partner, GRA 3: It is best when men and women work equally and take care of the home, family and children"

lab val plh0308_v2_rec_tc_p plh0308_v2_rec

* Checking

* sort dyad pid syear

* list syear dyad pid gra_tc gra_tc_partner hid if dyad<36000 & dyad>34000, sepby(hid)

*****

* Person-specific indicator for constellations of plh0308_v2_rec_tc (GRA Item 3) in dyad

gen plh0308_v2_const_dyad=.

* 0 = Actor & partner: traditional

replace plh0308_v2_const_dyad=0 if plh0308_v2_rec_tc==0 & plh0308_v2_rec_tc_p==0

replace plh0308_v2_const_dyad=0 if plh0308_v2_rec_tc==0 & plh0308_v2_rec_tc_p==1

replace plh0308_v2_const_dyad=0 if plh0308_v2_rec_tc==1 & plh0308_v2_rec_tc_p==0

replace plh0308_v2_const_dyad=0 if plh0308_v2_rec_tc==1 & plh0308_v2_rec_tc_p==1

* 1 = Actor & partner: moderate

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==3

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==4

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==3 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==3 & plh0308_v2_rec_tc_p==3

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==3 & plh0308_v2_rec_tc_p==4

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==4 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==4 & plh0308_v2_rec_tc_p==3

replace plh0308_v2_const_dyad=1 if plh0308_v2_rec_tc==4 & plh0308_v2_rec_tc_p==4

* 2 = Actor & partner: egalitarian

replace plh0308_v2_const_dyad=2 if plh0308_v2_rec_tc==5 & plh0308_v2_rec_tc_p==5

replace plh0308_v2_const_dyad=2 if plh0308_v2_rec_tc==5 & plh0308_v2_rec_tc_p==6

replace plh0308_v2_const_dyad=2 if plh0308_v2_rec_tc==6 & plh0308_v2_rec_tc_p==5

replace plh0308_v2_const_dyad=2 if plh0308_v2_rec_tc==6 & plh0308_v2_rec_tc_p==6

* 3 = Actor: traditional, partner: moderate (v.v.)

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==0 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==0 & plh0308_v2_rec_tc_p==3

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==0 & plh0308_v2_rec_tc_p==4

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==1 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==1 & plh0308_v2_rec_tc_p==3

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==1 & plh0308_v2_rec_tc_p==4

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==0

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==3 & plh0308_v2_rec_tc_p==0

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==4 & plh0308_v2_rec_tc_p==0

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==1

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==3 & plh0308_v2_rec_tc_p==1

replace plh0308_v2_const_dyad=3 if plh0308_v2_rec_tc==4 & plh0308_v2_rec_tc_p==1

* 4 = Actor: moderate, partner: egalitarian (v.v.)

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==5

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==6

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==3 & plh0308_v2_rec_tc_p==5

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==3 & plh0308_v2_rec_tc_p==6

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==4 & plh0308_v2_rec_tc_p==5

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==4 & plh0308_v2_rec_tc_p==6

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==5 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==6 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==5 & plh0308_v2_rec_tc_p==3

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==6 & plh0308_v2_rec_tc_p==3

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==5 & plh0308_v2_rec_tc_p==4

replace plh0308_v2_const_dyad=4 if plh0308_v2_rec_tc==6 & plh0308_v2_rec_tc_p==4

* 5 = Actor: egalitarian, partner: traditional (v.v.)

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==5 & plh0308_v2_rec_tc_p==0

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==5 & plh0308_v2_rec_tc_p==1

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==5 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==6 & plh0308_v2_rec_tc_p==0

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==6 & plh0308_v2_rec_tc_p==1

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==6 & plh0308_v2_rec_tc_p==2

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==0 & plh0308_v2_rec_tc_p==5

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==1 & plh0308_v2_rec_tc_p==5

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==5

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==0 & plh0308_v2_rec_tc_p==6

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==1 & plh0308_v2_rec_tc_p==6

replace plh0308_v2_const_dyad=5 if plh0308_v2_rec_tc==2 & plh0308_v2_rec_tc_p==6

lab var plh0308_v2_const_dyad "Constellation of gender role attitudes in dyads (Item 3)"

lab val plh0308_v2_const_dyad gra_tc_const_pers

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward plh0308_v2_const_dyad, replace

*****************************************

* 2012:

* Recode plh0308_v1 to 0-3 (instead of 4-1)

recode plh0308_v1 (4=0) (3=1) (2=2) (1=3), into(plh0308_v1_rec)

lab def gra2012_rec 0 "(0) Completely disagree" 1 "(1) Disagree" 2 "(2) Agree" ///
3 "(3) Completely agree"

lab val plh0308_v1_rec gra2012_rec

lab var plh0308_v1_rec "Gender role attitude (2012, Ref. = Completely disagree)"

* Generate plh0308_v1 [GRA 2012] as a time-constant covariate 

gen plh0308_v1_tc=plh0308_v1_rec

bysort pid (syear): replace plh0308_v1_tc = plh0308_v1_tc[_n-1] if plh0308_v1_tc >= .

lab var plh0308_v1_tc "Gender role attitude (2012), time-constant"

lab val plh0308_v1_tc gra2012_rec

sort dyad pid syear

* Create indicator for partner's gender role attitudes 2012 (plh0308_v1_tc_partn)

sort dyad syear pid

gen plh0308_v1_tc_p=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace plh0308_v1_tc_p=plh0308_v1_tc[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad plh0308_v1_tc plh0308_v1_tc_partn pid hid if hid<100, sepby(hid)

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace plh0308_v1_tc_p=plh0308_v1_tc[_n-1] if !missing(plh0308_v1_tc) & missing(plh0308_v1_tc_p)

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward plh0308_v1_tc_p, replace

lab var plh0308_v1_tc_p "Partners' Gender role attitudes (2012)"

lab val plh0308_v1_tc_p gra2012_rec

******************************************
******************************************

* Create indicator for partner's worries about private economic situation (w_econ_priv_partner)

sort dyad syear pid

gen w_econ_priv_partner=.

* Fill w_econ_priv_partner with value from actor

bysort dyad syear: replace w_econ_priv_partner=w_econ_priv[_n-1]

* Fill w_econ_priv_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace w_econ_priv_partner=w_econ_priv[_n-1] if !missing(w_econ_priv) & missing(w_econ_priv_partner)

lab var w_econ_priv_partner "Worried about private economic situation (partner)"

lab val w_econ_priv_partner worries_inv

tab w_econ_priv_partner

***

* Create indicator for partner's worries about losing job (w_losing_job_partner)

sort dyad syear pid

gen w_losing_job_partner=.

* Fill w_losing_job_partner with value from actor

bysort dyad syear: replace w_losing_job_partner=w_losing_job[_n-1]

* Fill w_losing_job_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace w_losing_job_partner=w_losing_job[_n-1] if !missing(w_losing_job) & missing(w_losing_job_partner)

lab var w_losing_job_partner "Worried about losing job (partner)"

lab val w_losing_job_partner worries_inv

tab w_losing_job_partner

***

* Create indicator for partner's level of education (pgpsbil_dich_partner)

sort dyad syear pid

gen pgpsbil_dich_partner=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace pgpsbil_dich_partner=pgpsbil_dich[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad pgpsbil_dich pgpsbil_dich_partner pid hid, sepby(hid)

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace pgpsbil_dich_partner=pgpsbil_dich[_n-1] if !missing(pgpsbil_dich) & missing(pgpsbil_dich_partner)

lab val pgpsbil_dich_partner pgpsbil_d

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward pgpsbil_dich_partner, replace

lab var pgpsbil_dich_partner "Partners' Level of Education (dummy)"

lab val pgpsbil_dich_partner pgpsbil_d

* Checking

sort dyad pid syear

* list syear dyad pid pgpsbil_dich pgpsbil_dich_partner hid if dyad<36000 & dyad>34000, sepby(hid)

***

* Recode migration background to dummy variables

gen migback_dich = .

replace migback_dich = 0 if migback == 1

replace migback_dich = 1 if migback == 2 | migback == 3

lab var migback_dich "Migration background (dich.)"

lab def migback_dich 0 "None" 1 "Yes (indirect or direct)"

lab val migback_dich migback_dich

***

* Create indicator for partner's migration background (migback_dich_partner)

sort dyad syear pid

gen migback_dich_partner=.

* Fill migback_dich_partner with value from actor

bysort dyad syear: replace migback_dich_partner=migback_dich[_n-1]

* Fill migback_dich_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace migback_dich_partner=migback_dich[_n-1] if !missing(migback_dich) & missing(migback_dich_partner)

lab var migback_dich_partner "Migration background (partner, dich.)"

lab val migback_dich_partner migback_dich

tab migback_dich_partner

**

* Create indicator for partner's age (age_partner)

sort dyad syear pid

gen age_partner=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace age_partner=age[_n-1]

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace age_partner=age[_n-1] if !missing(age) & missing(age_partner)

lab var age_partner "Partner's age (years)"

**

* Create indicator for partner's time since labor market enty (time_lab_entry_partner)

sort pid syear

sort dyad syear pid

gen time_lab_entry_partner=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace time_lab_entry_partner=time_lab_entry[_n-1]

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace time_lab_entry_partner=time_lab_entry[_n-1] if !missing(time_lab_entry) & missing(time_lab_entry_partner)

lab var time_lab_entry_partner "Time since partner's labour market entry (years)"

***

* Create indicator for partner's net equivalent income (equiv_inc_net_l_in_1000e_p)

sort pid syear

sort dyad syear pid

gen equiv_inc_net_l_in_1000e_p=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace equiv_inc_net_l_in_1000e_p=equiv_inc_net_l_in_1000e[_n-1]

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace equiv_inc_net_l_in_1000e_p=equiv_inc_net_l_in_1000e[_n-1] if !missing(equiv_inc_net_l_in_1000e) & missing(equiv_inc_net_l_in_1000e_p)

lab var equiv_inc_net_l_in_1000e_p "Partner's equivalized household net income (in 1,000 Euro)"

***

* Create indicator for partner's subjective relevance of being successful in career (plh0107_pan_partn)

sort dyad syear pid

gen plh0107_pan_partn=.

* Fill migback_dich_partner with value from actor

bysort dyad syear: replace plh0107_pan_partn=plh0107_rec_panel[_n-1]

* Fill migback_dich_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace plh0107_pan_partn=plh0107_rec_panel[_n-1] if !missing(plh0107_rec_panel) & missing(plh0107_pan_partn)

lab var plh0107_pan_partn "Subjective relevance: Be successful in your career (partner, 4 cat., panel)"

lab val plh0107_pan_partn subj_rel

tab plh0107_pan_partn

******************************************

* Generate indicators for partner's jobtraining

* (1) Dummy: University degree = 1

sort dyad syear pid

gen jobtrain_uni_p=.

* Fill variable with value from actor

bysort dyad syear: replace jobtrain_uni_p=jobtrain_uni[_n-1]

* Fill variable with value from partner

gsort dyad syear -pid

bysort dyad syear: replace jobtrain_uni_p=jobtrain_uni[_n-1] if !missing(jobtrain_uni) & missing(jobtrain_uni_p)

lab var jobtrain_uni_p "Partner: Professional qualification: University degree (dummy)"

lab def jobtrain_uni_p 0 "(0) No university degree" 1 "(1) University degree"

lab val jobtrain_uni_p jobtrain_uni_p

tab jobtrain_uni_p

sort pid syear

***

* (2) Dummy: Qualification: yes = 1

sort dyad syear pid

gen jobtrain_qual_p=.

* Fill variable with value from actor

bysort dyad syear: replace jobtrain_qual_p=jobtrain_qual[_n-1]

* Fill variable with value from partner

gsort dyad syear -pid

bysort dyad syear: replace jobtrain_qual_p=jobtrain_qual[_n-1] if !missing(jobtrain_qual) & missing(jobtrain_qual_p)

lab var jobtrain_qual_p "Partner: Professional qualification obtained (dummy)"

lab def jobtrain_qual_p 0 "(0) No professional qualification obtained" 1 "(1) Professional qualification obtained"

lab val jobtrain_qual_p jobtrain_qual_p

tab jobtrain_qual_p

sort pid syear

***

* (3) Dummy: Qualification: Non-academic

sort dyad syear pid

gen jobtrain_nonac_p=.

* Fill variable with value from actor

bysort dyad syear: replace jobtrain_qual_p=jobtrain_nonac[_n-1]

* Fill variable with value from partner

gsort dyad syear -pid

bysort dyad syear: replace jobtrain_nonac_p=jobtrain_nonac[_n-1] if !missing(jobtrain_nonac) & missing(jobtrain_nonac_p)

lab var jobtrain_nonac_p "Partner: non-academic (dummy)"

lab def jobtrain_nonac_p 0 "(0) Professional qualification obtained" 1 "(1) No professional qualification obtained"

lab val jobtrain_nonac_p jobtrain_nonac_p

tab jobtrain_nonac_p

sort pid syear

***

* (4) Dummy: Qualification: no qualification

sort dyad syear pid

gen jobtrain_none_p=.

* Fill variable with value from actor

bysort dyad syear: replace jobtrain_qual_p=jobtrain_none[_n-1]

* Fill variable with value from partner

gsort dyad syear -pid

bysort dyad syear: replace jobtrain_none_p=jobtrain_none[_n-1] if !missing(jobtrain_none) & missing(jobtrain_none_p)

lab var jobtrain_none_p "Partner: Professional qualification: none (dummy)"

lab def jobtrain_none_p 0 "(0) University degree or no professional qualification" 1 "(1) Non-academic qualification"

lab val jobtrain_none_p jobtrain_none_p

tab jobtrain_none_p

sort pid syear

***

* Generate indicator for partners' duration of education 

sort dyad syear pid

gen pgbilzeit_partner=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace pgbilzeit_partner=pgbilzeit[_n-1]

* Checking

sort dyad syear pid

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace pgbilzeit_partner=pgbilzeit[_n-1] if !missing(pgbilzeit) & missing(pgbilzeit_partner)

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward pgbilzeit_partner, replace

lab var pgbilzeit_partner "Partners' duration of education"

tab pgbilzeit

tab pgbilzeit_partner

**********

* Generate indicator for partner working in civil service (pgoeffd_d_partner)

sort dyad syear pid

gen pgoeffd_d_partner=.

* Fill fixed_term_partner with value from actor

bysort dyad syear: replace pgoeffd_d_partner=pgoeffd_d[_n-1]

* Checking

sort dyad syear pid

* list syear a b c dyad pgpsbil_dich pgpsbil_dich_partner pid hid, sepby(hid)

* Fill fixed_term_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace pgoeffd_d_partner=pgoeffd_d[_n-1] if !missing(pgoeffd_d) & missing(pgoeffd_d_partner)

lab var pgoeffd_d_partner "Partner: working in civil service (dummy)"

lab val pgoeffd_d_partner pgoeffd_d

***

* Create indicator for partner's subjective relevance of happy marriage or relationship (plh0107_pan_partn)

sort dyad syear pid

gen plh0109_pan_partn=.

* Fill migback_dich_partner with value from actor

bysort dyad syear: replace plh0109_pan_partn=plh0109_rec_panel[_n-1]

* Fill migback_dich_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace plh0109_pan_partn=plh0109_rec_panel[_n-1] if !missing(plh0109_rec_panel) & missing(plh0109_pan_partn)

lab var plh0109_pan_partn "Subjective relevance: Happy marriage or relationship (partner, 4 cat., panel)"

lab val plh0109_pan_partn subj_rel

tab plh0109_pan_partn

***

* Create indicator for partner's subjective relevance of having children (plh0107_pan_partn)

sort dyad syear pid

gen plh0110_pan_partn=.

* Fill migback_dich_partner with value from actor

bysort dyad syear: replace plh0110_pan_partn=plh0110_rec_panel[_n-1]

* Fill migback_dich_partner with value from partner

gsort dyad syear -pid

bysort dyad syear: replace plh0110_pan_partn=plh0109_rec_panel[_n-1] if !missing(plh0110_rec_panel) & missing(plh0110_pan_partn)

lab var plh0110_pan_partn "Subjective relevance: Happy marriage or relationship (partner, 4 cat., panel)"

lab val plh0110_pan_partn subj_rel

tab plh0110_pan_partn

***

* Person-specific indicator for constellations of worries about private economic situation in dyads

gen w_econ_priv_const_pers=.

* 0 = Actor & partner: No worries

replace w_econ_priv_const_pers=0 if w_econ_priv==0 & w_econ_priv_partner==0

* 1 = Actor & partner: Some worries

replace w_econ_priv_const_pers=1 if w_econ_priv==1 & w_econ_priv_partner==1

* 2 = Actor & partner: Many worries

replace w_econ_priv_const_pers=2 if w_econ_priv==2 & w_econ_priv_partner==2

* 3 = Actor: No worries, partner: some worries (v.v.)

replace w_econ_priv_const_pers=3 if w_econ_priv==0 & w_econ_priv_partner==1

replace w_econ_priv_const_pers=3 if w_econ_priv==1 & w_econ_priv_partner==0

* 4 = Actor: Some worries, partner: Many worries (v.v.)

replace w_econ_priv_const_pers=4 if w_econ_priv==1 & w_econ_priv_partner==2

replace w_econ_priv_const_pers=4 if w_econ_priv==2 & w_econ_priv_partner==1

* 5 = Actor: No worries, partner: Many worries (v.v.)

replace w_econ_priv_const_pers=5 if w_econ_priv==0 & w_econ_priv_partner==2

replace w_econ_priv_const_pers=5 if w_econ_priv==2 & w_econ_priv_partner==0

lab var w_econ_priv_const_pers "Constellation of worries about private economic situation in dyads"

lab def worries_dyad 0 "(0) Actor, Partner: No worries" 1 "(1) A, P: Some worries" ///
2 "(2) A, P: Many worries" 3 "(3) A: No worries, P: some worries (v.v.)" ///
4 "(4) A: Some worries, P: Many worries (v.v.)" 5 "(5) A: No worries, P: Many worries (v.v.)"

lab val w_econ_priv_const_pers worries_inv_dyad

**

* Dyad-specific indicator for constellations of worries about private economic situation in dyads

gen w_econ_priv_const_dyad = w_econ_priv_const_pers if dyad_nr==1

lab var w_econ_priv_const_dyad "Constellation of worries about private economic situation in dyads (dyad-specific)"

lab val w_econ_priv_const_dyad worries_dyad

***

* Person-specific indicator for constellations of worries about losing job in dyads

gen w_losing_job_const_pers=.

* 0 = Actor & partner: No worries

replace w_losing_job_const_pers=0 if w_losing_job==0 & w_losing_job_partner==0

* 1 = Actor & partner: Some worries

replace w_losing_job_const_pers=1 if w_losing_job==1 & w_losing_job_partner==1

* 2 = Actor & partner: Many worries

replace w_losing_job_const_pers=2 if w_losing_job==2 & w_losing_job_partner==2

* 3 = Actor: No worries, partner: some worries (v.v.)

replace w_losing_job_const_pers=3 if w_losing_job==0 & w_losing_job_partner==1

replace w_losing_job_const_pers=3 if w_losing_job==1 & w_losing_job_partner==0

* 4 = Actor: Some worries, partner: Many worries (v.v.)

replace w_losing_job_const_pers=4 if w_losing_job==1 & w_losing_job_partner==2

replace w_losing_job_const_pers=4 if w_losing_job==2 & w_losing_job_partner==1

* 5 = Actor: No worries, partner: Many worries (v.v.)

replace w_losing_job_const_pers=5 if w_losing_job==0 & w_losing_job_partner==2

replace w_losing_job_const_pers=5 if w_losing_job==2 & w_losing_job_partner==0

lab var w_losing_job_const_pers "Constellation of worries about losing jobs in dyads"

lab val w_losing_job_const_pers worries_dyad

**

* Dyad-specific indicator for constellations of worries about losing job in dyads

gen w_losing_job_const_dyad = w_losing_job_const_pers if dyad_nr==1

lab var w_losing_job_const_dyad "Constellation of worries about losing job in dyads (dyad-specific)"

lab val w_losing_job_const_dyad worries_dyad

***

* Person-specific indicator for constellations of educational levels in dyads

gen pgpsbil_dich_const_pers=.

* 0 = Actor & partner: No A-levels

replace pgpsbil_dich_const_pers=0 if pgpsbil_dich==0 & pgpsbil_dich_partner==0

* 1 = Actor & partner: A-levels

replace pgpsbil_dich_const_pers=1 if pgpsbil_dich==1 & pgpsbil_dich_partner==1

* 2 = Actor: A-levels, partner: No A-levels (v.v.)

replace pgpsbil_dich_const_pers=2 if pgpsbil_dich==1 & pgpsbil_dich_partner==0

replace pgpsbil_dich_const_pers=2 if pgpsbil_dich==0 & pgpsbil_dich_partner==1

lab var pgpsbil_dich_const_pers "Constellation of educational level in dyads (person-specific)"

lab def pgpsbil_dich_const_pers 0 "(0) Actor, Partner: No A-levels" 1 "(1) A, P: A-levels" ///
2 "(2) A: A-levels, P: No A-levels (v.v.)"

lab val pgpsbil_dich_const_pers pgpsbil_dich_const_pers

** Fill gaps between to episodes of the same kind

sort pid syear

bysort pid (syear): carryforward pgpsbil_dich_const_pers, replace

**

* Dyad-specific indicator for constellations of educational levels in dyads

gen pgpsbil_dich_const_dyad = pgpsbil_dich_const_pers if dyad_nr==1

lab var pgpsbil_dich_const_dyad "Constellation of educational level in dyads (dyad-specific)"

lab val pgpsbil_dich_const_dyad pgpsbil_dich_const_pers

***

* Person-specific indicator for constellations of migration background in dyads

gen migback_dich_const_pers=.

* 0 = Actor & partner: No migration background

replace migback_dich_const_pers=0 if migback_dich==0 & migback_dich_partner==0

* 1 = Actor & partner: Yes, migration background

replace migback_dich_const_pers=1 if migback_dich==1 & migback_dich_partner==1

* 2 = Actor: Yes, migration background, partner: No migration background (v.v.)

replace migback_dich_const_pers=2 if migback_dich==1 & migback_dich_partner==0

replace migback_dich_const_pers=2 if migback_dich==0 & migback_dich_partner==1

lab var migback_dich_const_pers "Constellation of migration background in dyads"

lab def migback_dich_const_pers 0 "(0) Actor, Partner: No migration background" 1 "(1) A, P: Yes, migration background" ///
2 "(2) A: Yes, migration background, P: No migration background (v.v.)"

lab val migback_dich_const_pers migback_dich_const_pers

**

* Dyad-specific indicator for constellations of migration background in dyads

gen migback_dich_const_dyad = migback_dich_const_pers if dyad_nr==1

lab var migback_dich_const_dyad "Constellation of migration background in dyads (dyad-specific)"

lab val migback_dich_const_dyad migback_dich_const_pers

***

* Person-specific indicator for constellations of subjective relevance of being successful in career

gen plh0107_con_pers=.

* 0 = Actor & partner: Very unimportant

replace plh0107_con_pers=0 if plh0107_rec_panel==0 & plh0107_pan_partn==0

* 1 = Actor & partner: Unimportant

replace plh0107_con_pers=1 if plh0107_rec_panel==1 & plh0107_pan_partn==1

* 2 = Actor & partner: Important

replace plh0107_con_pers=2 if plh0107_rec_panel==2 & plh0107_pan_partn==2

* 3 = Actor & partner: Very important

replace plh0107_con_pers=3 if plh0107_rec_panel==3 & plh0107_pan_partn==3

* 4 = Actor: very unimportant & partner: Unimportant (v.v.)

replace plh0107_con_pers=4 if plh0107_rec_panel==0 & plh0107_pan_partn==1

replace plh0107_con_pers=4 if plh0107_rec_panel==1 & plh0107_pan_partn==0

* 5 = Actor: very unimportant & partner: Important (v.v.)

replace plh0107_con_pers=5 if plh0107_rec_panel==0 & plh0107_pan_partn==2

replace plh0107_con_pers=5 if plh0107_rec_panel==2 & plh0107_pan_partn==0

* 6 = Actor: very unimportant & partner: Very important (v.v.)

replace plh0107_con_pers=6 if plh0107_rec_panel==0 & plh0107_pan_partn==3

replace plh0107_con_pers=6 if plh0107_rec_panel==3 & plh0107_pan_partn==0

* 7 = Actor: Unimportant & partner: Important (v.v.)

replace plh0107_con_pers=7 if plh0107_rec_panel==1 & plh0107_pan_partn==2

replace plh0107_con_pers=7 if plh0107_rec_panel==2 & plh0107_pan_partn==1

* 8 = Actor: Unimportant & partner: Very important (v.v.)

replace plh0107_con_pers=8 if plh0107_rec_panel==1 & plh0107_pan_partn==3

replace plh0107_con_pers=8 if plh0107_rec_panel==3 & plh0107_pan_partn==1

* 9 = Actor: Important & partner: Very important (v.v.)

replace plh0107_con_pers=9 if plh0107_rec_panel==2 & plh0107_pan_partn==3

replace plh0107_con_pers=9 if plh0107_rec_panel==3 & plh0107_pan_partn==2

lab var plh0107_con_pers "Constellation of subjective relevance of being successful in your career in dyads"

lab def subj_rel_dyad 0 "(0) Actor, Partner: Very unimportant" 1 "(1) A, P: Unimportant" ///
2 "(2) A, P: Important" 3 "(3) A, P: Very important" 4 "(4) A: Very unimportant, P: Unimportant (v.v.)" ///
5 "(5) A: Very unimportant, P: Important (v.v.)" 6 "(6) A: Very unimportant, P: Very important (v.v.)" ///
7 "(7) A: Unimportant, P: Important (v.v.)" 8 "(8) A: Unimportant, P: Very important (v.v.)" ///
9 "(9) A: Important, P: Very important (v.v.)"

lab val plh0107_con_pers subj_rel_dyad

**

* Dyad-specific indicator for Constellation of subjective relevance of being successful in your career in dyads

gen plh0107_con_dyad = plh0107_con_pers if dyad_nr==1

lab var plh0107_con_dyad "Constellation of subjective relevance of being successful in your career in dyads (dyad-specific)"

lab val plh0107_con_dyad subj_rel_dyad

***

* Person-specific indicator for constellations of subjective relevance of happy marriage or relationship

gen plh0109_con_pers=.

* 0 = Actor & partner: Very unimportant

replace plh0109_con_pers=0 if plh0109_rec_panel==0 & plh0109_pan_partn==0

* 1 = Actor & partner: Unimportant

replace plh0109_con_pers=1 if plh0109_rec_panel==1 & plh0109_pan_partn==1

* 2 = Actor & partner: Important

replace plh0109_con_pers=2 if plh0109_rec_panel==2 & plh0109_pan_partn==2

* 3 = Actor & partner: Very important

replace plh0109_con_pers=3 if plh0109_rec_panel==3 & plh0109_pan_partn==3

* 4 = Actor: very unimportant & partner: Unimportant (v.v.)

replace plh0109_con_pers=4 if plh0109_rec_panel==0 & plh0109_pan_partn==1

replace plh0109_con_pers=4 if plh0109_rec_panel==1 & plh0109_pan_partn==0

* 5 = Actor: very unimportant & partner: Important (v.v.)

replace plh0109_con_pers=5 if plh0109_rec_panel==0 & plh0109_pan_partn==2

replace plh0109_con_pers=5 if plh0109_rec_panel==2 & plh0109_pan_partn==0

* 6 = Actor: very unimportant & partner: Very important (v.v.)

replace plh0109_con_pers=6 if plh0109_rec_panel==0 & plh0109_pan_partn==3

replace plh0109_con_pers=6 if plh0109_rec_panel==3 & plh0109_pan_partn==0

* 7 = Actor: Unimportant & partner: Important (v.v.)

replace plh0109_con_pers=7 if plh0109_rec_panel==1 & plh0109_pan_partn==2

replace plh0109_con_pers=7 if plh0109_rec_panel==2 & plh0109_pan_partn==1

* 8 = Actor: Unimportant & partner: Very important (v.v.)

replace plh0109_con_pers=8 if plh0109_rec_panel==1 & plh0109_pan_partn==3

replace plh0109_con_pers=8 if plh0109_rec_panel==3 & plh0109_pan_partn==1

* 9 = Actor: Important & partner: Very important (v.v.)

replace plh0109_con_pers=9 if plh0109_rec_panel==2 & plh0109_pan_partn==3

replace plh0109_con_pers=9 if plh0109_rec_panel==3 & plh0109_pan_partn==2

lab var plh0109_con_pers "Constellation of subjective relevance of happy marriage or relationship in dyads"

lab val plh0109_con_pers subj_rel_dyad

**

* Dyad-specific indicator for Constellation of subjective relevance of happy marriage or relationship in dyads

gen plh0109_con_dyad = plh0109_con_pers if dyad_nr==1

lab var plh0109_con_dyad "Constellation of subjective relevance of happy marriage or relationship in dyads (dyad-specific)"

lab val plh0109_con_dyad subj_rel_dyad

***

* Person-specific indicator for constellations of subjective relevance of having children

gen plh0110_con_pers=.

* 0 = Actor & partner: Very unimportant

replace plh0110_con_pers=0 if plh0110_rec_panel==0 & plh0110_pan_partn==0

* 1 = Actor & partner: Unimportant

replace plh0110_con_pers=1 if plh0110_rec_panel==1 & plh0110_pan_partn==1

* 2 = Actor & partner: Important

replace plh0110_con_pers=2 if plh0110_rec_panel==2 & plh0110_pan_partn==2

* 3 = Actor & partner: Very important

replace plh0110_con_pers=3 if plh0110_rec_panel==3 & plh0110_pan_partn==3

* 4 = Actor: very unimportant & partner: Unimportant (v.v.)

replace plh0110_con_pers=4 if plh0110_rec_panel==0 & plh0110_pan_partn==1

replace plh0110_con_pers=4 if plh0110_rec_panel==1 & plh0110_pan_partn==0

* 5 = Actor: very unimportant & partner: Important (v.v.)

replace plh0110_con_pers=5 if plh0110_rec_panel==0 & plh0110_pan_partn==2

replace plh0110_con_pers=5 if plh0110_rec_panel==2 & plh0110_pan_partn==0

* 6 = Actor: very unimportant & partner: Very important (v.v.)

replace plh0110_con_pers=6 if plh0110_rec_panel==0 & plh0110_pan_partn==3

replace plh0110_con_pers=6 if plh0110_rec_panel==3 & plh0110_pan_partn==0

* 7 = Actor: Unimportant & partner: Important (v.v.)

replace plh0110_con_pers=7 if plh0110_rec_panel==1 & plh0110_pan_partn==2

replace plh0110_con_pers=7 if plh0110_rec_panel==2 & plh0110_pan_partn==1

* 8 = Actor: Unimportant & partner: Very important (v.v.)

replace plh0110_con_pers=8 if plh0110_rec_panel==1 & plh0110_pan_partn==3

replace plh0110_con_pers=8 if plh0110_rec_panel==3 & plh0110_pan_partn==1

* 9 = Actor: Important & partner: Very important (v.v.)

replace plh0110_con_pers=9 if plh0110_rec_panel==2 & plh0110_pan_partn==3

replace plh0110_con_pers=9 if plh0110_rec_panel==3 & plh0110_pan_partn==2

lab var plh0110_con_pers "Constellation of subjective relevance of having children

lab val plh0110_con_pers subj_rel_dyad

**

* Dyad-specific indicator for Constellation of subjective relevance of having children in dyads

gen plh0110_con_dyad = plh0110_con_pers if dyad_nr==1

lab var plh0110_con_dyad "Constellation of subjective relevance of having children in dyads (dyad-specific)"

lab val plh0110_con_dyad subj_rel_dyad

*******************************

* For missing-statistics: define Initial missings in empl_ind

* Define initial missings

sort pid syear

* Assign person-years:

bysort pid (syear): gen pid_yr=_n

sort pid syear

* Replace initial missings

gen empl_ind_miss=empl_ind

by pid (syear): replace empl_ind_miss=7 if pid_yr==1 & missing(empl_ind)

by pid: replace empl_ind_miss=7 if empl_ind_miss[_n-1]==7 & missing(empl_ind_miss)

***

* Define terminal missings

gsort pid -syear

* Assign person-years (from end to start per person)

by pid: gen pid_yr_bw=_n

* Replace terminal missings

gsort pid -syear

by pid: replace empl_ind_miss=8 if pid_yr_bw==1 & missing(empl_ind_miss)

gsort pid -syear

by pid: replace empl_ind_miss=8 if empl_ind_miss[_n-1]==8 & missing(empl_ind_miss)

***

* Define gaps

replace empl_ind_miss = 9 if empl_ind_miss == .

***

* Variable labels and value labels

lab var empl_ind_miss "Employment indicator, incl. missing-indicators (7 cat.)"

lab def empl_ind_miss 0 "(0) Permanent employment" 1 "(1) Fixed-term employment" 2 "(2) Unemployed or inactive" 3 "(3) Other" ///
7 "(7) Initial missings" 8 "(8) Terminal missings" 9 "(9) Gaps"

lab val empl_ind_miss empl_ind_miss

fre empl_ind_miss empl_ind

* Drop person-year-variables

sort pid syear

drop pid_yr pid_yr_bw

***************************

* For missing-statistics: define empl_ind_carryf with missing-indicators

sort pid syear

gen empl_ind_miss_gaps=empl_ind_miss

replace empl_ind_miss_gaps=. if empl_ind_miss_gaps==9

bysort pid (syear): carryforward empl_ind_miss_gaps, gen(empl_ind_carryf_miss)

***

* Variable labels and value labels

lab var empl_ind_carryf_miss "Employment indicator, incl. missing-indicators (7 cat.)"

lab val empl_ind_carryf_miss empl_ind_miss


*****

* Save

sort pid syear

save "${path_hdd}\240507 - pl dyads wp1.dta", replace

**************************************************************************************

* use "${path_hdd}\240507 - pl dyads wp1.dta"

* Generate Samples:

* Restrict samples to years 2012 and after (2012 = first measure for GRA, see below)

* drop if syear < 1990

* Restrict sample to hetero-sexual couples

* drop if sexor_dyad_dich==1

***

* XTSET

xtset pid syear

**************************************************************************************

*** Descriptives: Employment constellations and sociostructural background

* How many dyad-episodes in full dataset?

xtsum dyad_ind if syear > 1990 & dyad_nr == 1

* Person-episodes (not in table)

xttab sexor_dyad_dich if syear > 1990 & dyad_nr == 1

*** Not reported in tables:

* Respondents' duration of labour market participation

xtsum time_lab_entry if syear > 1990 & dyad_nr == 1

* Households' net equivalent disposable income per year (in 1000 euro)

xtsum equiv_inc_net_l_in_1000e if syear > 1990 & dyad_nr == 1

* Personal net income per month (in 1000 euro)

xtsum inc_1000 if syear > 1990 & dyad_nr == 1

* Males:

xtsum inc_1000 if syear > 1990 & dyad_nr == 1 & gender == 0

* Females:

xtsum inc_1000 if syear > 1990 & dyad_nr == 1 & gender == 1

* Respondents' age

xtsum age if syear > 1990 & dyad_nr == 1

* (Table 2) Types of episodes of employment constellations in couples:

eststo empl_const_dyad: estpost tabulate empl_const_dyad if syear > 1990 & dyad_nr == 1

esttab empl_const_dyad ///
using "${tables}\240531-tab_02_empl_const.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Comuples' employment constellations}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Share of missing dyad-episodes:

disp 159861/264488

* Person-numbers (not in table)

xttab empl_const_pers if syear > 1990 & dyad_nr == 1

* (Table 3) Constellations of 'Worried about private economic situation'

eststo w_econ_priv_const_dyad: estpost tabulate w_econ_priv_const_dyad if syear > 1990 & dyad_nr == 1

esttab w_econ_priv_const_dyad ///
using "${tables}\240531-tab_03_w_econ_priv_const.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of worries about private economic situation}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab w_econ_priv_const_pers if syear > 1990 & dyad_nr == 1

* (Table 4) Constellations of 'Worried about losing job'

eststo w_losing_job_const_dyad: estpost tabulate w_losing_job_const_dyad if syear > 1990 & dyad_nr == 1

esttab w_losing_job_const_dyad ///
using "${tables}\240531-tab_04_w_losing_job_const.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of worries about losing job}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* (Table 5) Constellations of 'Education'

eststo pgpsbil_dich_const_dyad: estpost tabulate pgpsbil_dich_const_dyad if syear > 1990

esttab pgpsbil_dich_const_dyad ///
using "${tables}\240531-tab_05_pgpsbil_dich_const.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of educational levels}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab pgpsbil_dich_const_pers if syear > 1990 & dyad_nr == 1

* (Table 6) Constellations of 'Migration background'

eststo migback_dich_const_dyad: estpost tabulate migback_dich_const_dyad if syear > 1990 & dyad_nr == 1

esttab migback_dich_const_dyad ///
using "${tables}\240531-tab_06_migback_dich_const.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of migration backgrounds}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab migback_dich_const_pers if syear > 1990 & dyad_nr == 1

*** Indicators for non-independence: Associations between partner-measures

xtset pid syear

* Employment constellation:

tab empl_ind empl_ind_partner if syear > 1990 & dyad_nr == 1 , chi2 V

kap empl_ind empl_ind_partner if syear > 1990 & dyad_nr == 1

mlogit empl_ind ib0.empl_ind_partner if syear > 1990 & dyad_nr == 1 , baseoutcome(0) vce(cluster dyad) rrr

margins, dydx (*) predict (pr outcome(1))

* Worried about private economic situation

tab w_econ_priv w_econ_priv_partner if syear > 1990 & dyad_nr == 1 , chi2 V

kap w_econ_priv w_econ_priv_partner if syear > 1990 & dyad_nr == 1

spearman w_econ_priv w_econ_priv_partner if syear > 1990 & dyad_nr == 1

xtologit w_econ_priv w_econ_priv_partner if syear > 1990 & dyad_nr == 1 , or

* Worried about jobloss

tab w_losing_job w_losing_job_partner if syear > 1990 & dyad_nr == 1 , chi2 V

kap w_losing_job w_losing_job_partner if syear > 1990 & dyad_nr == 1

spearman w_losing_job w_losing_job_partner if syear > 1990 & dyad_nr == 1

xtologit w_losing_job w_losing_job_partner if syear > 1990 & dyad_nr == 1 , or

* Education levels

tab pgpsbil_dich pgpsbil_dich_partner if syear > 1990 & dyad_nr == 1 , chi2 V

kap pgpsbil_dich pgpsbil_dich_partner if syear > 1990 & dyad_nr == 1

xtlogit pgpsbil_dich pgpsbil_dich_partner if syear > 1990 & dyad_nr == 1 , or

* Migration backgrounds

tab migback_dich migback_dich_partner if syear > 1990 & dyad_nr == 1 , chi2 V

kap migback_dich migback_dich_partner if syear > 1990 & dyad_nr == 1

xtlogit migback_dich migback_dich_partner if syear > 1990 & dyad_nr == 1 , or

*****

** Proportions of important relationship-events (not reported in tables)

* Cohabitation:

xtsum cohab_status if syear>1990 & dyad_nr==1

* Marriage:

xtsum married_status if syear>1990 & dyad_nr==1

* Birth of child:

xtsum child_born_status if syear>1990 & dyad_nr==1

* Divorce, separation, or widowhood

xtsum divorced_status if syear>1990 & dyad_nr==1

*** Descriptives: Types of partnerships, family-related attitudes

* (Table 7) Frequencies: Sexual orientations in couples

eststo sexor_dyad_dich_dy: estpost tabulate sexor_dyad_dich_dy if syear > 1990 & dyad_nr == 1

esttab sexor_dyad_dich_dy ///
using "${tables}\240531-tab_07_sexor_dyad_dich.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' sexual orientations}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab sexor_dyad_dich if syear > 1990 & dyad_nr == 1

*** (Table 8) Constellation of 'Subjective relevance of being successful in your career' (plh0107_con_dyad)

eststo plh0107_con_dyad: estpost tabulate plh0107_con_dyad if syear > 1990 & dyad_nr == 1

esttab plh0107_con_dyad ///
using "${tables}\240531-tab_08_subj_rel_career_constel.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of subjective relevance of being successful in your career}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab plh0107_con_dyad if syear>1990 & dyad_nr == 1

*** (Table 9) Constellation of 'Subjective relevance of happy marriage or relationship' (plh0109_con_dyad)

eststo plh0109_con_dyad: estpost tabulate plh0109_con_dyad if syear > 1990 & dyad_nr == 1

esttab plh0109_con_dyad ///
using "${tables}\240531-plh0109_con_dyad.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of subjective relevance of happy marriage or relationship}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab plh0109_con_dyad if syear>1990 & dyad_nr == 1

*** (Table 10) Constellation of 'Subjective relevance of having children' (plh0110_con_dyad)

eststo plh0110_con_dyad: estpost tabulate plh0110_con_dyad if syear > 1990 & dyad_nr == 1

esttab plh0110_con_dyad ///
using "${tables}\tab_10_subj_rel_children_constel.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of subjective relevance of being successful in your career}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab plh0110_con_dyad if syear>1990 & dyad_nr == 1

plh0300_v2 /// Gender role attitude 2018 only, 7 cat. : "You should get married if you live with your partner for a long time."
plh0302_v2 /// Gender role attitude 2018 only, 7 cat. : "Child younger than three years suffers when mother works"
plh0308_v2 /// Gender role attitude 2018 only, 7 cat. : "It is best when men and women work equally and take care of the home, family and children."

* (Table 11) Constellations of 'Gender role attitudes Item 1' (2018 and after)

eststo plh0300_v2_const_dyad: estpost tabulate plh0300_v2_const_dyad if syear > 1990 & dyad_nr == 1

esttab plh0300_v2_const_dyad ///
using "${tables}\240531-tab_11_gra_tc_const_it1.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of gender role attitudes, item 1: You should get married if you live with your partner for a long time}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab plh0300_v2_const_dyad if syear > 2017 & dyad_nr == 1

* (Table 12) Constellations of 'Gender role attitudes Item 2' (2018 and after)

eststo plh0302_v2_const_dyad: estpost tabulate plh0302_v2_const_dyad if syear > 1990 & dyad_nr == 1

esttab plh0302_v2_const_dyad ///
using "${tables}\240531-tab_12_gra_tc_const_it2.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of gender role attitudes, item 2: Child younger than three years suffers when mother works}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab plh0302_v2_const_dyad if syear > 2017 & dyad_nr == 1

* (Table 13) Constellations of 'Gender role attitudes Item 3' (2018 and after)

eststo plh0308_v2_const_dyad: estpost tabulate plh0308_v2_const_dyad if syear > 1990 & dyad_nr == 1

esttab plh0308_v2_const_dyad ///
using "${tables}\240531-tab_13_gra_tc_const_it3.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Couples' constellations of gender role attitudes, item 3: It is best when men and women work equally and take care of the home, family and children}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* Person-numbers (not in table)

xttab plh0308_v2_const_dyad if syear > 2017 & dyad_nr == 1

*** Indicators for non-independence: Associations between partner-measures

* Constellations of sexual orientations in couples

tab sexor_actor sexor_partner if syear > 1990 & dyad_nr == 1 , chi2 V

kap sexor_actor sexor_partner if syear > 1990 & dyad_nr == 1

xtlogit sexor_actor sexor_partner if syear > 1990 & dyad_nr == 1 , or

* Constellation of 'Subjective relevance of being successful in your career'

tab plh0107_rec_panel plh0107_pan_partn if syear > 1990 & dyad_nr == 1 , chi2 V

kap plh0107_rec_panel plh0107_pan_partn if syear > 1990 & dyad_nr == 1

spearman plh0107_rec_panel plh0107_pan_partn if syear > 1990 & dyad_nr == 1

xtologit plh0107_rec_panel plh0107_pan_partn if syear > 1990 & dyad_nr == 1 , or

* Constellation of 'Subjective relevance of marriage or relationship'

tab plh0109_rec_panel plh0109_pan_partn if syear > 1990 & dyad_nr == 1 , chi2 V

kap plh0109_rec_panel plh0109_pan_partn if syear > 1990 & dyad_nr == 1

spearman plh0109_rec_panel plh0109_pan_partn if syear > 1990 & dyad_nr == 1

xtologit plh0109_rec_panel plh0109_pan_partn if syear > 1990 & dyad_nr == 1 , or

* Constellation of 'Subjective relevance of having children'

tab plh0110_rec_panel plh0110_pan_partn if syear > 1990 & dyad_nr == 1 , chi2 V

kap plh0110_rec_panel plh0110_pan_partn if syear > 1990 & dyad_nr == 1

spearman plh0110_rec_panel plh0110_pan_partn if syear > 1990 & dyad_nr == 1

xtologit plh0110_rec_panel plh0110_pan_partn if syear > 1990 & dyad_nr == 1 , or

* Gender role attitudes: Item 1

tab plh0300_v2_rec_tc plh0300_v2_rec_tc_p if syear > 1990 & dyad_nr == 1 , chi2 V

kap plh0300_v2_rec_tc plh0300_v2_rec_tc_p if syear > 1990 & dyad_nr == 1

pwcorr plh0300_v2_rec_tc plh0300_v2_rec_tc_p if dyad_nr==1 & syear == 2018 , sig

reg plh0300_v2_rec_tc plh0300_v2_rec_tc_p if dyad_nr==1 & syear==2018 , beta

* Gender role attitudes: Item 2

tab plh0302_v2_rec_tc plh0302_v2_rec_tc_p if syear > 1990 & dyad_nr == 1 , chi2 V

kap plh0302_v2_rec_tc plh0302_v2_rec_tc_p if syear > 1990 & dyad_nr == 1

pwcorr plh0302_v2_rec_tc plh0302_v2_rec_tc_p if dyad_nr==1 & syear == 2018 , sig

reg plh0302_v2_rec_tc plh0302_v2_rec_tc_p if dyad_nr==1 & syear==2018 , beta

* Gender role attitudes: Item 3

tab plh0308_v2_rec_tc plh0308_v2_rec_tc_p if syear > 1990 & dyad_nr == 1 , chi2 V

kap plh0308_v2_rec_tc plh0308_v2_rec_tc_p if syear > 1990 & dyad_nr == 1

pwcorr plh0308_v2_rec_tc plh0308_v2_rec_tc_p if dyad_nr==1 & syear == 2018 , sig

reg plh0308_v2_rec_tc plh0308_v2_rec_tc_p if dyad_nr==1 & syear==2018 , beta

***************************************************

* Missing data and transitions in the individual occupational biographies

fre empl_ind if syear > 1990

* (Table 17a) Missing individual emplyoment data

eststo empl_ind_miss: estpost tabulate empl_ind_miss if syear > 1990

esttab empl_ind_miss ///
using "${tables}\240531-tab_17a_empl_ind_miss.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Missing individual emplyoment data}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* (Table 17b) Individual emplyoment data after filling in sequence-gaps

eststo empl_ind_carryf_miss: estpost tabulate empl_ind_carryf_miss if syear > 1990

esttab empl_ind_carryf_miss ///
using "${tables}\240531-tab_17b_empl_ind_carryf_miss.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Individual emplyoment data after filling in sequence-gaps}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace

* (Table 18) Individual labour market transitions

xttrans empl_ind_miss if syear > 1990 , freq

xttrans empl_ind_carryf_miss if syear > 1990 , freq
/*
eststo empl_ind_miss_trans: xttrans empl_ind_miss if syear > 1990 , freq

esttab empl_ind_miss_trans ///
using "${tables}\240531-tab_18_empl_ind_miss_trans.tex" , style(tex) ///
cells("b(fmt(%2.0f)label(Episodes)) pct(fmt(%2.1f)label(Perc.)) cumpct(fmt(%2.1f)label(Cum. Perc.))") ///
title({Individual labour market transitions}) ///
varlabels(`e(labels)', blist(Total))      ///
varwidth(55) nonumber nomtitle noobs ///
replace
*/

***************************************************

**** Statistics 2018 and after

*** Descriptives

* How many dyad-episodes in full dataset?

xttab dyad_ind if syear > 2017 & !missing(empl_const_pers)

* Employment constellations in dyads, person-numbers (not in table)

xttab empl_const_pers if syear > 2017 & dyad_nr == 1

* Constellations of gender role attitudes in dyads, person-numbers (not in table)

xttab gra_tc_const_pers if syear > 2017 & dyad_nr == 1

* Constellations of educational levels in dyads, person-numbers (not in table)

xttab pgpsbil_dich_const_pers if syear > 2017 & dyad_nr == 1

* Constellations of migration backgrounds in dyads, person-numbers (not in table)

xttab migback_dich_const_pers if syear > 2017 & dyad_nr == 1