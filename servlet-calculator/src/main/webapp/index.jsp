<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Simple Calculator</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
        }
        fieldset {
            width: 450px;
            padding: 20px 25px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        legend {
            font-weight: bold;
            font-size: 18px;
            padding: 0 8px;
        }
        table {
            width: 100%;
        }
        td {
            padding: 8px 0;
        }
        input[type="text"], select {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            padding: 10px 20px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }
    </style>
</head>
<body>

    <h1>Simple Calculator</h1>

    <fieldset>
        <legend>Calculator</legend>
        <form action="calculate" method="POST">
            <table>
                <tr>
                    <td>First operand:</td>
                    <td><input type="text" name="first-operand" required /></td>
                </tr>
                <tr>
                    <td>Operator:</td>
                    <td>
                        <select name="operator">
                            <option value="+">Addition (+)</option>
                            <option value="-">Subtraction (-)</option>
                            <option value="*">Multiplication (*)</option>
                            <option value="/">Division (/)</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Second operand:</td>
                    <td><input type="text" name="second-operand" required /></td>
                </tr>
                <tr>
                    <td></td>
                    <td><input type="submit" value="Calculate" /></td>
                </tr>
            </table>
        </form>
    </fieldset>

</body>
</html>
