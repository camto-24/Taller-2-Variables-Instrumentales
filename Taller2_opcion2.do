
**************************************************
****** Taller 2 - Evaluación de Impacto **********
**************************************************
********
clear all
cls
set more off, perm
cd "/Users/carolinacastroosorio/....."

ssc install ivreg2
ssc install ranktest
*use "oil_windfall_sin10perc.dta", clear

*Preparación: Eliminar el 10% de las obaservaciones aleatoriamente*

set seed 200812021



gen drop=rbinomial(1,0.1)


drop if drop==1



*Brazil has both onshore and offshore oil. For reasons we discuss below, it is easier to argue that offshore oil production is exogenous for AMC out- comes than onshore oil production. (...) oil-rich municipalities looked indistinguishable from municipalities that did not discover oil later in the century (conditional on appropriate controls).ONLY for offshore

*Nos quedamos con AMC costeros y en los que explotaciòn es en mar
gen sample=1 if coastal==1 & onshore==0
keep if sample==1
drop sample



* Punto 3*

encode sigla, gen(state)

reg mun_budget_revenue2000_pred_c oilandgasvalue2000_cap latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state 

eret list
*evaluar la F individual

test oilandgasvalue2000_cap
ret list

outreg2 using "outputs/punto3a.xls", append word keep(oilandgasvalue2000_cap latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí)
 

*opción 2
global X longitude1998 latitude1998 dist_federal_capital1998 					///
	dist_state_capital1998 state_capital

reghdfe mun_budget_revenue2000_pred_c oilandgasvalue2000_cap ${X}, a(sigla)
test oilandgasvalue2000_cap
local F = round(r(F),0.001)

outreg2 using "outputs/3_primera_etapa.xls", excel replace 	///
	keep(oilandgasvalue2000_cap) addtext(Prueba F, `F', Controles, Sí)			///
	label nocons
	
**# Punto 4

ivreg2 pmun_exp_funct_educ_cult2000c latitude1998 longitude1998 dist_federal_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)

outreg2 using "outputs/punto3a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí)

*ojo con 1 etapa
ivreg2 pmun_exp_funct_educ_cult2000c latitude1998 longitude1998 coastal dist_federal_capital1998 i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap), first

********
 

ivreg2 pmun_exp_funct_health_sanit2000c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "outputs/punto3a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 


*********************

*===============================================================================*
**# 4. Punto 5
*===============================================================================*
global y2 clroomsMunicipal_pop2005 estab_mun2002_without_pop km_paved_munic_c p_hhld_abovestrandard_ppl_2000 prc_hhld_with_power_2000		///
	welfare_2000_c

foreach var of global y2{
	ivreg2 `var' (mun_budget_revenue2000_pred_c=oilandgasvalue2000_cap) $C i.state 
	outreg2 using "outputs/IV.doc", keep (mun_budget_revenue2000_pred_c) append ctitle(`var')
}	





















ivreg2 pmun_exp_funct_hous_urban2000c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "outputs/punto3a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 

ivreg2 pmun_exp_funct_transport2000c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "outputs/punto3a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 

ivreg2 pmun_exp_funct_welf2000c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "outputs/punto3a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 


* Punto 4*

ivreg2 p_hhld_abovestrandard_ppl_2000 latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "outputs/punto4a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 

ivreg2 prc_hhld_with_power_2000 latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "punto4a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 

ivreg2 km_paved_munic_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "punto4a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 

ivreg2 clroomsMunicipal_pop2005 latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "punto4a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 

ivreg2 estab_mun2002_without_pop latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "punto4a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 

ivreg2 welfare_2000_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital i.state (mun_budget_revenue2000_pred_c= oilandgasvalue2000_cap)
outreg2 using "punto4a.xls", append word keep(mun_budget_revenue2000_pred_c latitude1998 longitude1998 coastal dist_federal_capital1998 dist_state_capital1998 state_capital) dec(3) addtext(Efectos Fijos de Estado, Sí) 
 
