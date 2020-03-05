/*
    Sample Unit Test to validate NorthwindTraders Categories table
    
    CREATE TABLE [dbo].[Categories]
    (
        [CategoryID] INT IDENTITY(1,1) NOT NULL,
        [CategoryName] NVARCHAR(15) NOT NULL,
        [Description] NTEXT NULL,
        [Picture] IMAGE NULL,
        CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
            (
                [CategoryID] ASC
            )
    )
    GO

*/

using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    [TestClass]
    public class Categories
    {
        public TestContext TestContext { get; set; }


        [TestMethod]
        [TestCategory("Model")]
        public void Categories_VerifySchema()
        {
            //Expected Schema
            string schema = @"<?xml version='1.0' standalone='yes'?>
<xs:schema id='NewDataSet' xmlns='' xmlns:xs='http://www.w3.org/2001/XMLSchema' xmlns:msdata='urn:schemas-microsoft-com:xml-msdata'>
    <xs:element name='NewDataSet' msdata:IsDataSet='true' msdata:UseCurrentLocale='true'>
        <xs:complexType>
        <xs:choice minOccurs='0' maxOccurs='unbounded'>
            <xs:element name='Categories'>
            <xs:complexType>
                <xs:sequence>
                <xs:element name='CategoryID' type='xs:int' minOccurs='0' />
                <xs:element name='CategoryName' type='xs:string' minOccurs='0' />
                <xs:element name='Description' type='xs:string' minOccurs='0' />
                <xs:element name='Picture' type='xs:base64Binary' minOccurs='0' />
                </xs:sequence>
            </xs:complexType>
            </xs:element>
        </xs:choice>
        </xs:complexType>
    </xs:element>
</xs:schema>";
            DataSet dsXsd = new DataSet();
            StringReader sr = new StringReader(schema);
            dsXsd.ReadXmlSchema(sr);
            DataTable t0 = dsXsd.Tables[0];

            //Current Schema
            SqlConnection cn = new SqlConnection("your connectionstring");
            SqlCommand cmd = new SqlCommand()
            {
                CommandText = "SELECT TOP 1 * FROM Categories",
                Connection = cn
            };
            cn.Open();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet dsDb = new DataSet();
            da.Fill(dsDb);
            DataTable t1 = dsDb.Tables[0];

            Assert.AreEqual(t0.Columns.Count, t1.Columns.Count, "Table structure failed validation");
            foreach (DataColumn c0 in t0.Columns)
            {
                if (t1.Columns.Contains(c0.ColumnName))
                {
                    DataColumn c1 = t1.Columns[c0.ColumnName];
                    Assert.AreEqual(c0.DataType, c1.DataType);
                }
                else
                {
                    Assert.Fail(String.Format("Column {0} failed validation", c0.ColumnName));
                    break;
                }
            }
        }
    }
}
