/* Replication file for the Appendix*/

clear all
use sanctions-II-replication.dta

* 0. list of control variables:
global controls "t_gdp s_gdp financial_san targeted_san capdist is_security is_econ is_hrts cinc_ratio post_coldwar sender_usa institution i.sender_regime past_success multiple "

* 1. Table Generation

* Table 1
eststo clear
foreach x of varlist l_tt t_tradeshare_mainUN t_tradeshare_altcow t_tradeshare_altUN t_tradeshare_alt_UNimputed1 {
	eststo: quietly mlogit m_outcome c.`x'##c.personalist_index $controls, baseoutcome(2) 
}
esttab using "sanction-II-table1.rtf", b(3) se replace
eststo clear

* Table 2
eststo clear
foreach x of varlist l_tt t_tradeshare_mainUN t_tradeshare_altcow t_tradeshare_altUN t_tradeshare_alt_UNimputed1 {
	eststo: quietly mlogit m_outcome c.`x'##ib3.target_regime $controls, baseoutcome(2) 
}
esttab using "sanction-II-table2.rtf", b(3) se replace
eststo clear

* 2. graph generation

* Figure 1

 foreach x of varlist l_tt t_tradeshare_mainUN {
	mlogit m_outcome c.`x'##c.personalist_index $controls, baseoutcome(2) 
	quietly sum `x', detail
	local lev1 =  r(mean) 
	local lev2 =  r(mean) + r(sd)
	local lev3 =  r(mean) + 2*r(sd)
	margins, at(`x'=(`lev3') personalist_index=(0(0.2)1)) predict(outcome(1))
	marginsplot, recastci(rarea)  yline(0, lcolor(red)) //bydimension(`x')
	graph export fig1_`x'.pdf, replace
}

* Figure 2: Figure 2 is produced in R, please see fig2.R for more information. 

* Figure 3 (All analyses were run on STATA and exported to R to produce Figure 2, please see fig2.R for more information)

foreach x of varlist l_tt t_tradeshare_mainUN t_tradeshare_altcow t_tradeshare_altUN t_tradeshare_alt_UNimputed1 {
	mlogit m_outcome c.`x'##ib3.target_regime $controls, baseoutcome(2) 
	quietly sum `x', detail
	local lev =  r(mean) + 2*r(sd)
	margins, at(`x'=(`lev') target_regime=(1 2 3)) predict(outcome(1))
	marginsplot, recast(scatter) yline(0, lcolor(red)) xscale(range(0.5,3.5))
	graph export fig3_`x'.pdf, replace
}

* Figure 4

	mlogit m_outcome c.l_tt##ib3.target_regime $controls, baseoutcome(2) 
	quietly sum l_tt, detail
	local mean_ = r(mean)
	local one_sd =  r(mean) + r(sd) 
	local two_sd =  r(mean) + 2*r(sd) 
	local mi_ = r(min)
	local ma_ = r(max)
    local step_ = (r(max)-r(min))/20
	margins, dydx(ib3.target_regime) at(l_tt=(`mi_' (`step_') `ma_') target_regime=(1 2)) predict(outcome(1)) post
	marginsplot, recastci(rarea) yline(0, lcolor(red)) bydimension(target_regime) xlabel(`mi_' "min" `ma_' "max" `mean_' "mean" `one_sd' "1sd" `two_sd' "2sd") 


*#####################

* 4. Coefficient Plot
global controls "t_gdp s_gdp financial_san targeted_san capdist is_security is_econ is_hrts cinc_ratio post_coldwar sender_usa institution i.sender_regime past_success multiple "
mlogit m_outcome c.l_tt##ib3.target_regime $controls,  baseoutcome(2) 
margins, dydx(*) predict(outcome(1))
marginsplot, horizontal recast(scatter) xline(0, lcolor(red)) xscale(range()) yscale(reverse)




