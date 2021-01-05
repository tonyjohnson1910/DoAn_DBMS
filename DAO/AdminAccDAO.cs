using DoAnDBMS.view;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DoAnDBMS.DAO
{
    class AdminAccDAO
    {
        private DataProvider dbProvider = new DataProvider();

        public bool checkLogInAdminInfo(Accounts adminAcc)
        {
            bool kt = true;

            try
            {
                DataTable tblC = new DataTable();
                tblC = dbProvider.ExecuteQuery("SELECT COUNT(*) FROM dbo.admin_accounts WHERE uname = '" + adminAcc.uname + "' AND upasswd = '" + adminAcc.upasswd + "'");
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
