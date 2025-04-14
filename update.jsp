<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="ISO-8859-1">

    <title>Update Student Details</title>

    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet" />

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>

    <h1>STUDENT UPDATE</h1>

    <% 
    String successMessage = request.getParameter("success");
    if ("true".equals(successMessage)) {
    %>
    <script>
        alert("Update successful!");
    </script>
    <% 
    }

    // Handle the update operation
    if (request.getParameter("submit") != null) {
        Connection con = null;
        PreparedStatement pst = null;
        try {
            String url = "jdbc:mysql://localhost:3306/institute1";
            String username = "root";
            String password = "set-password";
            con = DriverManager.getConnection(url, username, password);
            
            String id_1 = request.getParameter("id");
            String name = request.getParameter("sname");
            String course = request.getParameter("course");
            String fee = request.getParameter("fee");

            // Update query
            String updateQuery = "UPDATE records SET stname = ?, course = ?, fee = ? WHERE id = ?";
            pst = con.prepareStatement(updateQuery);
            pst.setString(1, name);
            pst.setString(2, course);
            pst.setInt(3, Integer.parseInt(fee));
            pst.setInt(4, Integer.parseInt(id_1));

            int rowsUpdated = pst.executeUpdate();
            if (rowsUpdated > 0) {
                // Redirect with success message
                response.sendRedirect("update.jsp?id=" + id_1 + "&success=true");
            } else {
                out.println("Error: Unable to update record.");
            }

        } catch (SQLException e) {
            out.println("Error: " + e.getMessage());
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        } finally {
            try {
                if (pst != null) pst.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    %>

    <div class="row">
        <div class="col-sm-4">
            <form method="post" action="update.jsp">
                <%
                    // Fetching the existing record details
                    Connection con = null;
                    PreparedStatement pst = null;
                    ResultSet res = null;

                    try {
                        String id_1 = request.getParameter("id");
                        int id = Integer.parseInt(id_1);

                        // Get the current details for the student to update
                        String query = "SELECT * FROM records WHERE id = ?";
                        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/institute1", "root", "set-password");
                        pst = con.prepareStatement(query);
                        pst.setInt(1, id);
                        res = pst.executeQuery();

                        while (res.next()) {
                %>
                <div>
                    <label class="form-label">Roll Number (ID)</label>
                    <input type="number" class="form-control" value="<%= res.getInt("id") %>" name="id" readonly>
                </div>
                <br>
                <div>
                    <label class="form-label">Student Name</label>
                    <input type="text" class="form-control" value="<%= res.getString("stname") %>" placeholder="Student Name" name="sname" required>
                </div>
                <br>
                <div>
                    <label class="form-label">Course</label>
                    <input type="text" class="form-control" value="<%= res.getString("course") %>" placeholder="Course Name" name="course" required>
                </div>
                <br>
                <div>
                    <label class="form-label">Fee</label>
                    <input type="number" class="form-control" value="<%= res.getInt("fee") %>" placeholder="Fee" name="fee" required>
                </div>
                <br>
                <%
                        }
                    } catch (SQLException e) {
                        out.println("Error fetching data: " + e.getMessage());
                    } catch (Exception e) {
                        out.println("Error: " + e.getMessage());
                    } finally {
                        try {
                            if (res != null) res.close();
                            if (pst != null) pst.close();
                            if (con != null) con.close();
                        } catch (SQLException e) {
                            out.println("Error closing resources: " + e.getMessage());
                        }
                    }
                %>
                <br>
                <div align="right">
                    <input type="submit" name="submit" value="Update" class="btn btn-info">
                    <input type="reset" value="Reset" class="btn btn-warning">
                </div>
                <br>
                <br>
                <div align="left">
                	<button  class="btn btn-outline-primary"><a href="index.jsp" class="btn btn-outline-primary" style="font-family: sans-serif; color: red;">
    Click Back
</a></button>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
