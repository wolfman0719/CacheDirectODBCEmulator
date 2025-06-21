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
   set namespace = params.NameSpace
   set timeout = params.TimeOut

   if (namespace '= "") && (namespace '= $namespace) {
     set $namespace = namespace
   }

   if (tPLIST'="") && (tPLIST'= $char(0)) {
     for i = 1:1:$length(tPLIST,PDELIM) {
       set PLIST(i) = $piece(tPLIST,PDELIM,i)
     }
   }
   set params.ErrorName = ""
   set params.ErrorStatus = 1
   set params.Error = 0
 
    if timeout < 1 { 
      //  実行するコードの中で、出力先を指定せずにWriteを発行した場合にエラーとなるのを防ぐ
      //  Prevent an error from occurring when Write is issued without specifying the output destination in the code to be executed.
      set curdev=$IO   // 現 Device を保持 store the current device
      // NULL Device にスイッチ
      // Switching to NULL Device
      set nulldev=##class(%Device).GetNullDevice()
      open nulldev
      use nulldev
      do ##class(%Device).ChangePrincipal() 
      xecute ecommand
      // 元の Device (curdev) に戻す
      // Restoring the original device
      use curdev
      do ##class(%Device).ChangePrincipal() 
      close nulldev  // Closing NULL deice
      
      do ..PropertyRestore()
    }
    else {
      // タイムアウト検知用のイベント生成
      // Create an event for timeout
      set eventname="CDExecute"_$job
      do $system.Event.Create(eventname)
      // timeoutの単位は、ミリ秒なので1000で割る
      // the unit of timeout value is milisecond
      
      set timeout = timeout/1000
   
      // JOBにローカル変数を渡すためローカル変数を一時グローバルにコピーする
      // Copy local variables to temp Globals to pass the parameters to JOB
      kill ^IRISTempCDEmu($Job)
      set ^IRISTempCDEmu($Job,"P0")=$Get(P0)
      set ^IRISTempCDEmu($Job,"P1")=$Get(P1)
      set ^IRISTempCDEmu($Job,"P2")=$Get(P2)
      set ^IRISTempCDEmu($Job,"P3")=$Get(P3)
      set ^IRISTempCDEmu($Job,"P4")=$Get(P4)
      set ^IRISTempCDEmu($Job,"P5")=$Get(P5)
      set ^IRISTempCDEmu($Job,"P6")=$Get(P6)
      set ^IRISTempCDEmu($Job,"P7")=$Get(P7)
      set ^IRISTempCDEmu($Job,"P8")=$Get(P8)
      set ^IRISTempCDEmu($Job,"P9")=$Get(P9)
      set ^IRISTempCDEmu($Job,"PLIST")=$Get(PLIST)
      set ^IRISTempCDEmu($Job,"PDELIM")=$Get(PDELIM)

      // ジョブ起動を行う
      // Kickoff a job
      Job ..ExecuteJob(ecommand)
      set childpid=$ZChild

      // ジョブ起動した子ジョブがタイムアウト時間内で終了するのを待つ
      // Wait for the jobbed process to complete within the timeout period
      set ret=$system.Event.Wait(eventname,timeout)
   
      if ret=$$$OK {
        // 起動ジョブがタイムアウト以内で完了
        // The jobbed process has been completed within the timeout period
        set VALUE=$Get(^IRISTempCDEmu($Job,"VALUE"))
        set P0=$Get(^IRISTempCDEmu($Job,"P0"))
        set P1=$Get(^IRISTempCDEmu($Job,"P1"))
        set P2=$Get(^IRISTempCDEmu($Job,"P2"))
        set P3=$Get(^IRISTempCDEmu($Job,"P3"))
        set P4=$Get(^IRISTempCDEmu($Job,"P4"))
        set P5=$Get(^IRISTempCDEmu($Job,"P5"))
        set P6=$Get(^IRISTempCDEmu($Job,"P6"))
        set P7=$Get(^IRISTempCDEmu($Job,"P7"))
        set P8=$Get(^IRISTempCDEmu($Job,"P8"))
        set P9=$Get(^IRISTempCDEmu($Job,"P9"))
        set PLIST=$Get(^IRISTempCDEmu($Job,"PLIST"))
        set PDELIM=$Get(^IRISTempCDEmu($Job,"PDELIM"))
        set VALUE=$Get(^IRISTempCDEmu($Job,"VALUE"))
        set params.Error = $Get(^IRISTempCDEmu($Job,"Error"))
        set params.ErrorName = $Get(^IRISTempCDEmu($Job,"ErrorName"))
        set params.ErrorStatus = $Get(^IRISTempCDEmu($Job,"ErrorStatus"))
        set params.ErrorDetail = $system.Status.GetErrorText(params.ErrorStatus)
        do ..PropertyRestore()

      } 
      else {
        // タイムアウト発生!!
        // Timeout has come!!
        set params.Error = 1
        set params.ErrorName = "<TIMEOUT> "
        set params.ErrorStatus = $$$ERROR($$$GeneralError,"Request timed out")
        set params.ErrorDetail = $system.Status.GetErrorText(params.ErrorStatus)
      }

      // ^IRISTempCDEmuとイベントのクリーンアップ
      // Crean up IRISTempCDEmu and the event
      kill ^IRISTempCDEmu($Job)
      do $system.Event.Delete(eventname)
    }  
 }
 catch error {
   do ..PropertyRestore()
   set params.ErrorName = error.Name
   set params.ErrorStatus = error.AsStatus()
   set params.ErrorDetail = $system.Status.GetErrorText(params.ErrorStatus)
   set params.Error = 1
 }
  
 kill P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,PLIST,PDELIM,VALUE 
 quit params.%ToJSON()
}

ClassMethod ExecuteJob(Command As %String) [ PublicList = (P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, PLIST, PDELIM, VALUE, Code) ]
{
  try {
    set parentpid=$ZParent
    set eventname="CDExecute"_parentpid
    set P0=$Get(^IRISTempCDEmu(parentpid,"P0"))
    set P1=$Get(^IRISTempCDEmu(parentpid,"P1"))
    set P2=$Get(^IRISTempCDEmu(parentpid,"P2"))
    set P3=$Get(^IRISTempCDEmu(parentpid,"P3"))
    set P4=$Get(^IRISTempCDEmu(parentpid,"P4"))
    set P5=$Get(^IRISTempCDEmu(parentpid,"P5"))
    set P6=$Get(^IRISTempCDEmu(parentpid,"P6"))
    set P7=$Get(^IRISTempCDEmu(parentpid,"P7"))
    set P8=$Get(^IRISTempCDEmu(parentpid,"P8"))
    set P9=$Get(^IRISTempCDEmu(parentpid,"P9"))
    set PLIST=$Get(^IRISTempCDEmu(parentpid,"PLIST"))
    set PDELIM=$Get(^IRISTempCDEmu(parentpid,"PDELIM"))

    xecute Command

    set ^IRISTempCDEmu(parentpid,"P0")=P0
    set ^IRISTempCDEmu(parentpid,"P1")=P1
    set ^IRISTempCDEmu(parentpid,"P2")=P2
    set ^IRISTempCDEmu(parentpid,"P3")=P3
    set ^IRISTempCDEmu(parentpid,"P4")=P4
    set ^IRISTempCDEmu(parentpid,"P5")=P5
    set ^IRISTempCDEmu(parentpid,"P6")=P6
    set ^IRISTempCDEmu(parentpid,"P7")=P7
    set ^IRISTempCDEmu(parentpid,"P8")=P8
    set ^IRISTempCDEmu(parentpid,"P9")=P9
    set ^IRISTempCDEmu(parentpid,"PLIST")=PLIST
    set ^IRISTempCDEmu(parentpid,"PDELIM")=PDELIM
    set ^IRISTempCDEmu(parentpid,"VALUE")=VALUE    

  }
  catch error {
    set ^IRISTempCDEmu(parentpid,"Error")=1
    set ^IRISTempCDEmu(parentpid,"ErrorName")=error.Name
    set ^IRISTempCDEmu(parentpid,"ErrorStatus") = error.AsStatus()
  }

  do $system.Event.Signal(eventname)
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

ClassMethod Version() As %String
{
  quit "V2.0"
}

}
