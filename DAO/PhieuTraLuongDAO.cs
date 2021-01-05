using DoAnDBMS.model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DoAnDBMS.DAO
{
    class PhieuTraLuongDAO
    {
        private DataProvider dbProvider = new DataProvider();

        public int getLuong(int thoid)
        {
            int luongthang;

            try
            {
                DataTable tableLuong = new DataTable();
                tableLuong = dbProvider.ExecuteQuery("SELECT func_getLuong(" + thoid + ")");
                luongthang = Convert.ToInt32((Convert.ToDouble(tableLuong.Rows[0][0].ToString())));
            }
            catch (System.Exception)
            {
                luongthang = -1;
                throw;
            }

            return luongthang;
        }
    }
}
