<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %> 

<%
    // Logic for form submission
    if(request.getParameter("submit") != null) {
        String rollNumberStr = request.getParameter("rollnumber");  // Get roll number
        String name = request.getParameter("sname");
        String course = request.getParameter("course");
        String feeStr = request.getParameter("fee");

        Connection con = null;
        PreparedStatement pst = null;
        
        try {
            int rollNumber = Integer.parseInt(rollNumberStr); // Convert roll number to integer
            int fee = Integer.parseInt(feeStr); // Convert fee to integer

            // Loading the MySQL JDBC driver

            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = "jdbc:mysql://localhost:3306/institute1";
            String username = "root";
            String password = "set-password";
            
            con = DriverManager.getConnection(url, username, password);


            // Insert the custom roll number (id), along with the name, course, and fee
            pst = con.prepareStatement("INSERT INTO records(id, stname, course, fee) VALUES (?, ?, ?, ?)");

            pst.setInt(1, rollNumber);  // Manually set the roll number

            pst.setString(2, name);

            pst.setString(3, course);

            pst.setInt(4, fee);
            
            int rowsAffected = pst.executeUpdate();

            if (rowsAffected > 0) {
%>
                <script>

                    alert("Record added successfully!");

                    window.location.href = 'index.jsp';
                     // Redirect after 
                     
                </script>
<%
            } 
            else
             {
%>
                <script>

                    alert("Failed to add record.");

                </script>
<%
            }
        } 
        catch (NumberFormatException e) 
        { 
%>
            <script>
                
                alert("Invalid input! Please check your roll number and fee.");
            </script>
<%
        }
         catch (Exception e) 
         {
%>
            <script>
               
               alert("Error: <%= e.getMessage() %>");
            </script>
<%
        } 
        finally 
        {
            try 
            {
                if (pst != null) pst.close();
                if (con != null) con.close();

            } 
            catch (SQLException e) 
            {
%>
                <script>
                    alert("Database connection close error: <%= e.getMessage() %>");
                </script>
<%
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Student Registration</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
    <h1>STUDENT REGISTRATION SYSTEM</h1>
    <div class="row">
        <div class="col-sm-4">
            <form method="post" action="index.jsp">
                <div>
                    <label class="form-label">Roll Number (ID)</label>
                    <input type="number" class="form-control" placeholder="Roll Number" name="rollnumber" required>
                </div>
                <br>
                <div>
                    <label class="form-label">Student Name</label>
                    <input type="text" class="form-control" placeholder="Student Name" name="sname" required>
                </div>
                <br>
                <div>
                    <label class="form-label">Course</label>
                    <input type="text" class="form-control" placeholder="Course Name" name="course" required>
                </div>
                <br>
                <div>
                    <label class="form-label">Fee</label>
                    <input type="number" class="form-control" placeholder="Fee" name="fee" required>
                </div>
                <br>
                <div align="right">
                    <input type="submit" name="submit" value="Submit" class="btn btn-info">
                    <input type="reset" value="Reset" class="btn btn-warning">
                </div>
            </form>
        </div>

        <div class="col-sm-8">
            <div class="panel-body">
                <table class="table table-responsive table-bordered" cellpadding="0" width="100%">
                    <thead>
                        <tr>
                            <th>Roll Number (ID)</th>
                            <th>Student Name</th>
                            <th>Course</th>
                            <th>Fee</th>
                            <th>Edit</th>
                            <th>Delete</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        // Fetching records from the database and displaying them in the table
                        Connection con = null;
                        PreparedStatement pst = null;
                        ResultSet res = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String url = "jdbc:mysql://localhost:3306/institute1";
                            String username = "root";
                            String password = "set-password";
                            
                            con = DriverManager.getConnection(url, username, password);
                            
                            String query = "SELECT * FROM records";
                            Statement stmt = con.createStatement();
                            res = stmt.executeQuery(query);
                            
                            while (res.next()) {
                                int id = res.getInt("id");  
                                String stname = res.getString("stname");
                                String course = res.getString("course");
                                int fee = res.getInt("fee");
                        %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= stname %></td>
                            <td><%= course %></td>
                            <td><%= fee %></td>
                            <td><a href="update.jsp?id=<%= id %>">Edit</a></td> <!-- Edit link passing the id -->
                            <td><a href="delete.jsp?id=<%= id %>">Delete</a></td> <!-- Delete link -->
                        </tr>
                        <% 
                            }
                        }
                         catch (SQLException e) 
                         {
                            out.println("Error fetching data: " + e.getMessage());
                        } 
                        catch (Exception e)
                        {
                            out.println("Error: " + e.getMessage());
                        } 
                        finally 
                        {
                            try 
                            {
                                if (res != null) res.close();
                                if (pst != null) pst.close();
                                if (con != null) con.close();
                            }
                             catch (SQLException e) 
                             {
                                out.println("Error closing resources: " + e.getMessage());
                            }
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
