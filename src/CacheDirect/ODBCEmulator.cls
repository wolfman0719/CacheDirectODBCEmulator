Class CacheDirect.ODBCEmulator
{

ClassMethod Execute(Command As %String(MAXLEN=1000), Params As %String(MAXLEN=64000)) As %String(MAXLEN=64000) [ PublicList = (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, PLIST, PDELIM, VALUE, Code, params), SqlProc ]
{
 try {
	 	  
   if ($extract(Command,1) = "=") {		   
     set ecommand="Set VALUE="_$extract(Command,2,*)
   }
   elseif ($extract(Command,1) = "$") {
     set ecommand="Set VALUE="_Command
   }
   else {
	 set ecommand = Command
   }
      
   set params = {}.%FromJSON(Params)
   set P0=params.P0
   set P1=params.P1
   set P2=params.P2
   set P3=params.P3
   set P4=params.P4
   set P5=params.P5
   set P6=params.P6
   set P7=params.P7
   set P8=params.P8
   set P9=params.P9
   set tPLIST=params.PLIST
   set PDELIM = params.PDELIM

   if (tPLIST'="") && (tPLIST'= $char(0)) {
     for i = 1:1:$length(tPLIST,PDELIM) {
	   set PLIST(i) = $piece(tPLIST,PDELIM,i)
     }
   }
   set params.iErrorName = ""
   set params.iError = 0
 
   xecute ecommand
   do ..PropertyRestore()
 }
 catch error {
   do ..PropertyRestore()
   set params.iErrorName = error.Name
   set params.iError = 1
   set params.ErrorStatus = error.AsStatus()
   set params.Error = 1
 }
  
 kill P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,PLIST,PDELIM,VALUE 
 quit params.%ToJSON()
}

ClassMethod PropertyRestore() As %Status [ PublicList = (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, PLIST, PDELIM, VALUE, Code, params) ]
{
  set params = {}	
  if $data(VALUE) set params.VALUE=VALUE
  if $data(P0) set params.P0 = P0
  if $data(P1) set params.P1 = P1
  if $data(P2) set params.P2 = P2
  if $data(P3) set params.P3 = P3
  if $data(P4) set params.P4 = P4
  if $data(P5) set params.P5 = P5
  if $data(P6) set params.P6 = P6
  if $data(P7) set params.P7 = P7
  if $data(P8) set params.P8 = P8
  if $data(P9) set params.P9 = P9
  if $data(PDELIM) set params.PDELIM = PDELIM
  if $data(Code) set params.Code = Code
  kill plist
  set node = "",plistcount = 0
  for {
	 set node = $order(PLIST(node))
	 if node = "" quit
	    set plistcount = plistcount + 1
	    set plist(plistcount) = PLIST(node)
     }
     if +$get(PLIST) = 0 {
	   set PLIST = plistcount
       for i = 1:1:PLIST {
	     set PLISTS = $get(PLISTS)_PDELIM_$get(plist(i))
       }
       set params.PLIST = $extract($get(PLISTS),2,*)
     }
     else {
       for i = 1:1:PLIST {
	     set PLISTS = $get(PLISTS)_PDELIM_$get(PLIST(i))
       }
       set params.PLIST = $extract($get(PLISTS),2,*)
     }
}

ClassMethod Test() As %Status
{
  set p ={}
  set p.P0 = "abc;def;ghi"
  set p.P1 = ";"
  set p.P2 = ""
  set p.P3 = ""
  set p.P4 = ""
  set p.P5 = ""
  set p.P6 = ""
  set p.P7 = ""
  set p.P8 = ""
  set p.P9 = ""
  set p.PLIST = ""
  set p.PDELIM = ";"
  set p.ErrorName = ""
  set p.Code = ""
  set p.Value = ""
  set params = p.%ToJSON()
  set result = ..Execute("=$piece(P0,P1,2)",params)
  write result,!
  quit $$$OK
}

ClassMethod StoredProcTest() As %Status
{
  set p ={}
  set p.P0 = "abc;def;ghi"
  set p.P1 = ";"
  set p.P2 = ""
  set p.P3 = ""
  set p.P4 = ""
  set p.P5 = ""
  set p.P6 = ""
  set p.P7 = ""
  set p.P8 = ""
  set p.P9 = ""
  set p.PLIST = ""
  set p.PDELIM = ";"
  set p.ErrorName = ""
  set p.Code = ""
  set p.Value = ""
  set params = p.%ToJSON()
  set tStatement = ##class(%SQL.Statement).%New()
  set tStatus = tStatement.%Prepare("?=call CacheDirect.ODBCEmulator_Execute(?,?)")
  set result = tStatement.%Execute(,"=$piece(P0,P1,2)",params)
  set position = 0
  set value = result.%NextOutputValue(.position)
  set value = result.%NextOutputValue(.position)
  write value,!
  quit $$$OK
}

}
