using DoAnDBMS.model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DoAnDBMS.DAO
{
    class BangChamCongDAO
    {
        private DataProvider dbProvider = new DataProvider();

        public bool chamcongvao(int thoid)
        {
            bool kt = true;
            try
            {
                dbProvider.ExecuteNonQuery("EXEC proc_chamcong_vao @thoid = " + thoid);
            }
            catch (Exception e)
            {
                kt = false;
            }

            return kt;
        }

        public bool chamcongra(int thoid)
        {
            bool kt = true;

            try
            {
                dbProvider.ExecuteNonQuery("EXEC proc_chamcong_ra @thoid = " + thoid);
            }
            catch (System.Exception)
            {
                kt = false;
                throw;
            }

            return kt;
        }

        public BangChamCong getBangChamCongTho(int thoid)
        {
            BangChamCong bccT = new BangChamCong();

            try
            {
                DataTable tblBCC = new DataTable();
                tblBCC = dbProvider.ExecuteQuery("SELECT * FROM dbo.bangchamcong WHERE tho_id = " + thoid);
                bccT.tho_id = thoid;
                bccT.thoigianvaolam = Convert.ToDateTime(tblBCC.Rows[0][1]);
                bccT.thoigiantanlam = Convert.ToDateTime(tblBCC.Rows[0][2]);
            } catch (Exception)
            {
                throw;
            }

            return bccT;
        }
    }
}
