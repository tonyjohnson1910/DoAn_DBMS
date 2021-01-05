using DoAnDBMS.conn;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DoAnDBMS.DAO
{
    class DataProvider
    {
        private My_DB dbconn;

        public DataTable ExecuteQuery(string query)
        {
            dbconn = new My_DB();

            DataTable dataTable = new DataTable();

            using (SqlConnection conn = dbconn.getConnection)
            {
                dbconn.openConnection();

                SqlCommand command = new SqlCommand(query, conn);
                SqlDataAdapter adapter = new SqlDataAdapter(command);
                adapter.Fill(dataTable);

                dbconn.closeConnection();
            }
            return dataTable;
        }

        public void ExecuteNonQuery(string query)
        {
            dbconn = new My_DB();

            using (SqlConnection conn = dbconn.getConnection)
            {
                dbconn.openConnection();

                SqlCommand command = new SqlCommand(query, conn);
                command.ExecuteNonQuery();
                dbconn.closeConnection();
            }
        }

        public void ExecuteNonQueryIncludeImage(string query, MemoryStream pic)
        {
            dbconn = new My_DB();

            using (SqlConnection conn = dbconn.getConnection)
            {
                dbconn.openConnection();

                SqlCommand command = new SqlCommand(query + " @img", conn);
                command.Parameters.Add("@img", SqlDbType.Image).Value = pic.ToArray();
                command.ExecuteNonQuery();
                dbconn.closeConnection();
            }
        }
    }
}
