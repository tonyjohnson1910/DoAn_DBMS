using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DoAnDBMS.model;
using DoAnDBMS.view;

namespace DoAnDBMS.DAO
{
    class ThoDAO
    {
        private DataProvider dbProvider = new DataProvider();

        public bool insTho(Accounts thoacc, ThoInfo thoinfo)
        {
            bool kt = true;

            try
            {
                dbProvider.ExecuteNonQueryIncludeImage("EXEC dbo.proc_insTho @uname = '" + thoacc.uname + "', @passwd = '" + thoacc.upasswd + "', @acctype = " + thoacc.vaitro + ", @fname = N'" + thoinfo.fname + "', @lname = N'" + thoinfo.lname + "', @img = ", thoinfo.hinhanh);
            } catch (Exception)
            {
                kt = false;
                throw;
            }
            return kt;
        }

        public bool changeThoImg(int thoid, MemoryStream pic)
        {
            bool kt = true;

            try
            {
                dbProvider.ExecuteNonQueryIncludeImage("EXEC dbo.proc_editThoImage @uid = 0, @img = ", pic);
            } catch (Exception)
            {
                kt = false;
                throw;
            }

            return kt;
        }

        public bool changeThoPasswd(int thoid, string passwd)
        {
            bool kt = true;

            try
            {
                dbProvider.ExecuteNonQuery("EXEC dbo.proc_changeThoPasswd @uid = " + thoid + ", @passwd = '" + passwd + "'");
            } catch (Exception)
            {
                kt = false;
                throw;
            }

            return kt;
        }

        public bool delTho(int thoid)
        {
            bool kt = true;

            try
            {
                dbProvider.ExecuteNonQuery("EXEC dbo.proc_delTho @uid = " + thoid);
            } catch(Exception)
            {
                kt = false;
                throw;
            }

            return kt;
        }

        public ThoInfo getThoInfo(int thoid)
        {
            ThoInfo tho = new ThoInfo();

            try
            {
                DataTable tblOneTho = new DataTable();
                tblOneTho = dbProvider.ExecuteQuery("SELECT * FROM dbo.tho_infos WHERE userid = " + thoid);

                tho.fname = tblOneTho.Rows[0][1].ToString();
                tho.lname = tblOneTho.Rows[0][2].ToString();
                tho.hinhanh = new MemoryStream((byte[])tblOneTho.Rows[0][3]);
            } catch (Exception)
            {
                throw;
            }

            return tho;
        }

        public bool checkLoginInfoTho(Accounts thoAcc)
        {
            bool kt = true;

            try
            {
                DataTable tblC = new DataTable();
                
                tblC = dbProvider.ExecuteQuery("SELECT COUNT(*) FROM dbo.tho_accounts WHERE uname = '" + thoAcc.uname + "' AND upasswd = '" + thoAcc.upasswd + "'");
                kt = (Convert.ToInt32(tblC.Rows[0][0]) > 0) ? true : false;
            } catch (Exception)
            {
                kt = false;
                throw;
            }

            return kt;
        }
    }
}
