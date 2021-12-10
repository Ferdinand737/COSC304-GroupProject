<!DOCTYPE html>
<html>
<head>
<title>SignUp Screen</title>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Enter your Information</h3>


<br>
<form name="MyForm" method=post action="createAccount.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">First Name:</font></div></td>
	<td><input type="text" name="firstName"  size=20 maxlength=40></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Last Name:</font></div></td>
	<td><input type="text" name="lastName" size=20 maxlength="40"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Email:</font></div></td>
	<td><input type="text" name="email" size=20 maxlength="50"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Phone Number:</font></div></td>
	<td><input type="text" name="phonenum" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Street Address:</font></div></td>
	<td><input type="text" name="address" size=20 maxlength="50"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">City:</font></div></td>
	<td><input type="text" name="city" size=20 maxlength="40"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">State:</font></div></td>
	<td><input type="text" name="state" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Postal Code:</font></div></td>
	<td><input type="text" name="postalCode" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Country:</font></div></td>
	<td><input type="text" name="country" size=20 maxlength="40"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="userid" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=20 maxlength="30"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Sign Up!">
</form>

</div>

</body>
</html>

