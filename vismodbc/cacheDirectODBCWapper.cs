using System;
using System.Data;
using System.Data.Odbc;
using System.Timers;
using Newtonsoft.Json;

namespace cachedirectodbc
{

    [JsonObject("Vism")]
    public class Vism
    {
        [JsonProperty("P0")]
        public string P0 { get; set; }

        [JsonProperty("P1")]
        public string P1 { get; set; }

        [JsonProperty("P2")]
        public string P2 { get; set; }

        [JsonProperty("P3")]
        public string P3 { get; set; }

        [JsonProperty("P4")]
        public string P4 { get; set; }

        [JsonProperty("P5")]
        public string P5 { get; set; }

        [JsonProperty("P6")]
        public string P6 { get; set; }

        [JsonProperty("P7")]
        public string P7 { get; set; }

        [JsonProperty("P8")]
        public string P8 { get; set; }

        [JsonProperty("P9")]
        public string P9 { get; set; }

        [JsonProperty("PLIST")]
        public string PLIST { get; set; }

        [JsonProperty("PDELIM")]
        public string PDELIM { get; set; }

        [JsonProperty("Code")]
        public string Code { get; set; }

        [JsonProperty("ErrorName")]
        public string ErrorName { get; set; }

        [JsonProperty("Value")]
        public string Value { get; set; }

        [JsonProperty("Error")]
        public long Error { get; set; }

        [JsonProperty("inamespace")]
        public string inamespace { get; set; }

    }

    public class cacheDirectODBCWapper
    {
		public OdbcConnection odbcCon;
        public event EventHandler ErrorEvent;
        public event EventHandler ExecuteEvent;

        private System.Timers.Timer timer = new System.Timers.Timer();

        private string p0;
        private string p1;
        private string p2;
        private string p3;
        private string p4;
        private string p5;
        private string p6;
        private string p7;
        private string p8;
        private string p9;
        private string plist;
        private string pdelim;
        private string value;
        private string code;
        private long execflag;
        private string errorname;
        private long error;
        private long interval;
        private string inamespace;

        private void Init()
        {
            this.p0 = "";
            this.p1 = "";
            this.p2 = "";
            this.p3 = "";
            this.p4 = "";
            this.p5 = "";
            this.p6 = "";
            this.p7 = "";
            this.p8 = "";
            this.p9 = "";
            this.plist = "";
            this.pdelim = "\r\n";
            this.error = 0;
            this.code = "";
            this.value = "";
            this.errorname = "";
            this.inamespace = "";
        }

        private void Exec3(object source, ElapsedEventArgs e)
        {
            timer.Stop();
            this.Execute(this.code);
            this.execflag = 0;
        }


        protected virtual void OnError()
        {
            ErrorEvent?.Invoke(this, EventArgs.Empty);
        }

        protected virtual void Executed()
        {
            ExecuteEvent?.Invoke(this, EventArgs.Empty);
        }

        public string P0
        {
            set 
            { 
                this.p0 = value;
            }
            get { return this.p0; }
        }
        public string P1
        {
            set 
            { 
                this.p1 = value;
            
            }
            get { return this.p1; }
        }
        public string P2
        {
            set 
            { 
                this.p2 = value;
            }
            get { return this.p2; }
        }
        public string P3
        {
            set 
            { 
                this.p3 = value;
            }
            get { return this.p3; }
        }
        public string P4
        {
            set 
            { 
                this.p4 = value;
            }
            get { return this.p4; }
        }
        public string P5
        {
            set 
            { 
                this.p5 = value;
            }
            get { return this.p5; }
        }
        public string P6
        {
            set 
            { 
                this.p6 = value;
            }
            get { return this.p6; }
        }
        public string P7
        {
            set 
            { 
                this.p7 = value;
            }
            get { return this.p7; }
        }
        public string P8
        {
            set 
            { 
                this.p8 = value;
            }
            get { return this.p8; }
        }
        public string P9
        {
            set 
            { 
                this.p9 = value;
            }
            get { return this.p9; }
        }
        public string PLIST
        {
            set 
            { 
                this.plist = value;
            }
            get { return this.plist; }
        }
        public string PDELIM
        {
            set 
            { 
                this.pdelim = value;
            }
            get { return this.pdelim; }
        }
        public string VALUE
        {
            set 
            { 
                this.value = value;
            }
            get
            {
                if (this.execflag == 2)
                {
                    this.Execute(this.code);
                    this.execflag = 0;
                }
                return this.value;
            }
        }
        public string Code
        {
            set { this.code = value; }
            get { return this.code; }
        }
        public long ExecFlag
        {
            set
            {
                this.execflag = value;
                if (value == 1)
                {
                    this.Execute(this.code);
                    this.execflag = 0;
                }
                else if (value == 2)
                {
                }
                else if (value == 3)
                {
                    timer.Interval = this.interval;
                    timer.AutoReset = true;
                    timer.Enabled = true;
                    timer.Elapsed += new ElapsedEventHandler(Exec3);

                    timer.Start();

                }
            }
            get { return this.execflag; }
        }

        public string NameSpace
        {
            set
            {
                this.inamespace = value;
                this.Execute("set $namespace=" + "" + value + "");
            }
            get
            {
                //return iris.ClassMethodString("CacheDirect.Emulator", "GetNamespace");
                return this.inamespace;
            }
        }
        public long Interval
        {
            set
            {
                this.interval = value;
            }
            get { return this.interval; }
        }
        public string ErrorName
        {
            get { return this.errorname; }
        }
        public string Error
        {
            get { return this.error.ToString(); }
        }


        public cacheDirectODBCWapper(string DSN)
        {
          //string DSN = @"IRIS User;UID=_system;PWD=SYS;";

		  OdbcConnectionStringBuilder odbcConBuilder = new OdbcConnectionStringBuilder();
          odbcConBuilder.ConnectionString = DSN;

          odbcCon = new OdbcConnection(odbcConBuilder.ToString());
          odbcCon.Open();
          Init();

        }

        public Boolean end()
        {

            try
            {
                odbcCon.Close();
            }
            finally
            {
            }
            return true;
        }

        public void Dispose()
        {

            try
            {
            }
            finally
            {
            }
        }

        public long Execute(string command)
        {
            long status;
			
            OdbcCommand cmd = new OdbcCommand();
            cmd.Connection = odbcCon;
			string callSQL = @"?=call CacheDirect.ODBCEmulator_Execute(?,?)";
            OdbcParameter param1 = new OdbcParameter();
            OdbcParameter param2 = new OdbcParameter();
            OdbcParameter param3 = new OdbcParameter();
			
			param1.DbType = DbType.String;
            param1.Direction = ParameterDirection.ReturnValue;
            param1.Size = 64000;
            cmd.Parameters.Add(param1);

			param2.DbType = DbType.String;
            param2.Value = command;
            cmd.Parameters.Add(param2);

            Vism jsonObj = new Vism
            {
                P0 = this.p0,
                P1 = this.p1,
                P2 = this.p2,
                P3 = this.p3,
                P4 = this.p4,
                P5 = this.p5,
                P6 = this.p6,
                P7 = this.p7,
                P8 = this.p8,
                P9 = this.p9,
                PLIST = this.plist,
                PDELIM = this.pdelim,
                Code = this.code,
                Value = this.value,
                ErrorName = this.errorname,
                Error = this.error,
                inamespace = this.inamespace
            };

			string paramsStr = JsonConvert.SerializeObject(jsonObj, Formatting.None);

			param3.DbType = DbType.String;
            param3.Value = paramsStr;
            cmd.Parameters.Add(param3);

            cmd.CommandText = callSQL; 
            cmd.ExecuteNonQuery();
			
			string props = param1.Value.ToString();
			
			Vism result = JsonConvert.DeserializeObject<Vism>(props);

            this.p0 = result.P0;
            this.p1 = result.P1;
            this.p2 = result.P2;
            this.p3 = result.P3;
            this.p4 = result.P4;
            this.p5 = result.P5;
            this.p6 = result.P6;
            this.p7 = result.P0;
            this.p8 = result.P8;
            this.p9 = result.P9;
            this.plist = result.PLIST;
            this.pdelim = result.PDELIM;
            this.code = result.Code;
            this.value = result.Value;
            this.errorname = result.ErrorName;
            this.error = result.Error;
            this.inamespace = result.inamespace;

            if (error == 1)
            {
                OnError();
            }

            Executed();

            status = error;

            return status;
        }

        public string getPLIST(int index)
        {
            string[] PLISTArray = { "" };

            string plist = this.PLIST;
			
            PLISTArray = plist.Split(this.PDELIM.ToCharArray());

            return PLISTArray[index - 1];
        }
        public long getPLISTLength()
        {
            string[] PLISTArray = { "" };

            string plist = this.PLIST;
            PLISTArray = plist.Split(this.PDELIM.ToCharArray());

            return PLISTArray.Length;
        }

        public Boolean setPLIST(int index, string replace)
        {
            string[] PLISTArray = { "" };

            string plist = this.PLIST;
            PLISTArray = plist.ToString().Split(this.PDELIM.ToCharArray());

            if (index <= PLISTArray.Length)
            {
                PLISTArray[index - 1] = replace;
                this.PLIST = string.Join(this.PDELIM, PLISTArray);
            }

            return true;
        }
        public string Version
        {
            get { return "V1.0"; }
        }
    }
}
