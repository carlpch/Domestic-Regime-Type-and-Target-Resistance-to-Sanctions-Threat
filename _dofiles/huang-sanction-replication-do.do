/* Replication file for the Appendix*/


clear all
use huang-sanction-replication

* list of other independent variables:
global controls "t_gdp s_gdp financial_san targeted_san capdist is_security is_econ is_hrts cinc_ratio post_coldwar sender_usa institution i.sender_regime past_success multiple "


* Table Generation
/* Appendix Table 1*/
eststo clear
foreach x of varlist l_tt t_tradeshare_mainUN t_tradeshare_altcow t_tradeshare_altUN t_tradeshare_alt_UNimputed1 {
	eststo: quietly mlogit m_outcome c.`x'##ib3.target_regime $controls,  baseoutcome(2) 
}
esttab using "sanction-rep-table.csv", se
eststo clear

/* Appendix Table 2*/
eststo clear
foreach x of varlist l_tt t_tradeshare_mainUN t_tradeshare_altcow t_tradeshare_altUN t_tradeshare_alt_UNimputed1 {
	eststo: quietly mlogit m_outcome c.`x'##c.pers_ratio $controls,  baseoutcome(2) 
}
esttab using "sanction-rep-table-perindex.csv", se
eststo clear

*#####################

* graph generation
cd "/Users/Carl/Dropbox/_research/_sanction/_replication" //directory for storing graphs
foreach x of varlist l_tt t_tradeshare_mainUN t_tradeshare_altcow t_tradeshare_altUN t_tradeshare_alt_UNimputed1 {
	mlogit m_outcome c.`x'##ib3.target_regime $controls,  baseoutcome(2) 
	quietly sum `x', detail
	local mi_ = r(min)
	local ma_ = r(max)
	local step_ = (r(max)-r(min))/10
	margins, at(`x'=(`mi_' (`step_') `ma_') target_regime=(1 2 3)) predict(outcome(1))
	marginsplot, recastci(rarea) bydimension(target_regime) yline(0, lcolor(red)) xlabel(`mi_'"min" `ma_' "max")
	graph export core_model_final_`x'.png, replace
}

cd "/Users/Carl/Dropbox/_research/_sanction/_replication/per-index" //directory for storing graphs
foreach x of varlist l_tt t_tradeshare_mainUN t_tradeshare_altcow t_tradeshare_altUN t_tradeshare_alt_UNimputed1 {
	mlogit m_outcome c.`x'##c.pers_ratio $controls,  baseoutcome(2) 
	quietly sum `x', detail
	local mi_ = r(min)
	local me_ = r(mean)
	local ma_ = r(max)
	margins, at(`x'=(`mi_' `me_' `ma_') pers_ratio=(0(0.2)1)) predict(outcome(1))
	marginsplot, recastci(rarea) bydimension(`x', elabels(1 "Trade Dependence = 0" 2 "Trade Dependence = Mean" 3 "Trade Dependence = Max")) yline(0, lcolor(red))
	graph export per_model_final_`x'.png, replace
}








