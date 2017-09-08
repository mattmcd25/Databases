import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Reporting 
{
	private static Scanner sc;
	
	public static void main(String[] args) 
	{
		if(args.length == 2)
		{
			System.out.println("1- Report Patient's Basic Information\n2- Report Doctor's Basic Information\n3- Report Admissions Information\n4- Update Admissions Payment\n");
			System.exit(0);
		}
		else if(args.length == 3)
		{
			String username = args[0];
			String password = args[1];
		
			int option = Integer.parseInt(args[2]);
			if(option < 1 || option > 4)
			{
				System.out.println("Invalid third parameter - must be 1-4\n");
				System.exit(1);
			}
			
			try {
				DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
				Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl",
																username, password);
				
				sc = new Scanner(System.in);
				if(option == 1) patientInfo(conn);
				else if(option == 2) doctorInfo(conn);
				else if(option == 3) admissionInfo(conn);
				else updateAdmission(conn);
				
				conn.close();
			}
			catch (SQLException e) {
				e.printStackTrace();
				System.exit(0);
			}
		}
		else
		{
			System.out.println("Invalid number of arguments.\n");
			System.exit(1);
		}
	}
	
	private static void patientInfo(Connection conn) throws SQLException 
	{
		System.out.print("Enter Patient SSN: ");
		String SSN = sc.nextLine();
		
		Statement stmt = conn.createStatement();
		
		String query = "SELECT * FROM Patient WHERE SSN='"+SSN+"'";
				
		ResultSet res = stmt.executeQuery(query);
		
		res.next();
		String fName = res.getString("firstName");
		String lName = res.getString("lastName");
		String address = res.getString("address");
		String phoneNum = res.getString("phoneNum");
		
		System.out.println("Patient SSN: " + SSN);
		System.out.println("Patient First Name: " + fName);
		System.out.println("Patient Last Name: " + lName);
		System.out.println("Patient Address: " + address);
		System.out.println("Patient Phone Number: " + phoneNum);
		System.out.println();
		
		res.close();
		
		stmt.close();
	}
	
	private static void doctorInfo(Connection conn) throws SQLException 
	{
		System.out.print("Enter Doctor ID: ");
		String ID = sc.nextLine();
		
		Statement stmt = conn.createStatement();
		
		String query = "SELECT * FROM Doctor WHERE ID="+ID;
				
		ResultSet res = stmt.executeQuery(query);
		
		res.next();
		
		String fName = res.getString("FirstName");
		String lName = res.getString("LastName");
		String gender = res.getString("gender");
		String specialty = res.getString("specialty");
		
		System.out.println("Doctor ID: " + ID);
		System.out.println("Doctor First Name: " + fName);
		System.out.println("Doctor Last Name: " + lName);
		System.out.println("Doctor Gender: " + gender);
		System.out.println("Doctor Specialty: " + specialty);
		System.out.println();
		
		res.close();
		
		stmt.close();
	}
	
	private static void admissionInfo(Connection conn) throws SQLException 
	{
		System.out.print("Enter Admission Number: ");
		String admitNum = sc.nextLine();
		
		Statement stmt = conn.createStatement();
		
		String query = "SELECT SSN, admitTime, totalPayment FROM Admission A WHERE A.Num = " + admitNum;	
		ResultSet res = stmt.executeQuery(query);
		
		res.next();
		
		String SSN = res.getString("SSN");
		String admitDate = res.getString("admitTime");
		String totalPayment = res.getString("totalPayment");
		
		System.out.println("Admission Number: " + admitNum);
		System.out.println("Patient SSN: " + SSN);
		System.out.println("Admission Date: " + admitDate);
		System.out.println("Total Payment: " + totalPayment);
		System.out.println("Rooms: ");
		
		String query2 = "SELECT RoomNum, startDate, endDate FROM StayIn WHERE AdmissionNum = " + admitNum;
		res = stmt.executeQuery(query2);
		
		while (res.next())
		{
			String roomNum = res.getString("RoomNum");
			String startDate = res.getString("startDate");
			String endDate = res.getString("endDate");
			System.out.println("\tRoomNum: " + roomNum + ", FromDate: " + startDate + ", ToDate: " + endDate);
		}
		
		System.out.println("Doctors	examined the patient in	this admission: ");
		String query3 = "SELECT DocID, comments FROM Examine WHERE AdmissionNum = " + admitNum;
		res = stmt.executeQuery(query3);
		
		while (res.next())
		{
			String DocID = res.getString("DocID");
			String comment = res.getString("comments");
			System.out.println("\tDoctor ID: " + DocID + ", Comments: " + comment);
		}
		
		System.out.println();
		
		res.close();
		
		stmt.close();
	}
	
	private static void updateAdmission(Connection conn) throws SQLException 
	{
		System.out.print("Enter Admission Number: ");
		String admitNum = sc.nextLine();
		System.out.print("Enter the new total payment: ");
		String newTotal = sc.nextLine();
		
		Statement stmt = conn.createStatement();
		
		String query = "UPDATE Admission SET totalPayment="+newTotal+" WHERE Num="+admitNum;
				
		ResultSet res = stmt.executeQuery(query);
		
		System.out.println();
		
		res.close();
		
		stmt.close();
	}
	
}