REM  *****  BASIC  *****


Public oSheet As Object


Sub MoveValuesAtEndOfMonth()

	oSheet = ThisComponent.getSheets().getByIndex(0) ' Get the first sheet
	Dim Men_viin As Integer
	Dim Muut As Integer
	Dim Viina As Integer
	Dim Menot As Integer
	Dim Total_sum As Integer
	
	Dim ArgArray(4) as Variant 
	
	' in this order: Men + Viin, Muut, Viina, menot, Total SUM
	ArgArray(0) = oSheet.getCellRangeByName("H37").getValue()
	ArgArray(1) = oSheet.getCellRangeByName("H35").getValue()
	ArgArray(2) = oSheet.getCellRangeByName("G35").getValue()
	ArgArray(3) = oSheet.getCellRangeByName("C35").getValue()
	ArgArray(4) = oSheet.getCellRangeByName("H38").getValue()
	
	Dim i As Integer
	For i = LBound(ArgArray) To UBound(ArgArray)
	    FindCell_InsertValue ArgArray(i) , 11 + i ' 11 = col L
	Next i

End Sub


Sub FindCell_InsertValue(valueToCopy As Integer, colIndex As Integer)

	Dim targetCell As Object
	Dim rowIndex As Integer
	Dim maxRow As Integer
	Dim emptyCellFound As Boolean
	
	rowIndex = 2
	maxRow = 13 ' no need to go further than row 14
	emptyCellFound = False
	
	Do While  rowIndex <= maxRow
		targetCell = oSheet.getCellByPosition(colIndex, rowIndex)
		If targetCell.getString() = "" Then
			emptyCellFound = True
			Exit Do
		End If
		rowIndex = rowIndex + 1
	Loop
	
	If emptyCellFound Then 'copy all values from I3-I33 to comment Muut(M=12) cell
		targetCell.setValue(valueToCopy)
		
		If colIndex = 12 Then
			Dim cellsToCopy As Variant
			Dim oCell As Object
			Dim Muut As Variant

			cellsToCopy = oSheet.getCellRangeByName("I3:I33")
		    ' Loop through each cell in the range
    		For i = 0 To cellsToCopy.Rows.Count - 1
        		For j = 0 To cellsToCopy.Columns.Count - 1
        			oCell = cellsToCopy.getCellByPosition(j, i)
            		If oCell.getString() = "" Then
						' pass trough
					Else
						Muut = Muut & oCell.getString() & Chr(13) & Chr(13)
					End If
        		Next j
    		Next i

	  	 	 Annotations = oSheet.getAnnotations()
	   		 Annotations.insertNew(targetCell.CellAddress, Muut)
		End If
		
		Else
			MsgBox "No empty cell found in column(L=11) " & colIndex & " row " & rowIndex & " for value " & valueToCopy & Chr(13) & "Exiting..."
			End ' stop the entire macro
	End If
End Sub

Sub EmptyCells_ChangeMonth

	oSheet = ThisComponent.getSheets().getByIndex(0) ' Get the first sheet

	' Menot column
	C3_C33 = oSheet.getCellRangeByName("C3:C33")
    For i = 0 To C3_C33.Rows.Count - 1
        oCell = C3_C33.getCellByPosition(0, i)
        oCell.setString("")
    Next i
    
    ' viin, muut & expl columns
    G3_I33 = oSheet.getCellRangeByName("G3:I33")
    For i = 0 To G3_I33.Rows.Count -1
    	For j = 0 To G3_I33.Columns.Count - 1
    		oCell = G3_I33.getCellByPosition(j, i)
        	oCell.setString("")
    	next j
    Next i

	' modify date
	dateCell = oSheet.getCellRangeByName("A3")

   	Dim currentDate As Date
    Dim currentYear As Integer
    Dim currentMonth As Integer
    Dim newDate As String
    
    currentDate = Date()
    currentYear = Year(currentDate)
    currentMonth = Month(currentDate)
   	newDate = "=DATE(" & currentYear & ", " & currentMonth & ", 1)"
   	dateCell.setFormula(newDate)
   	Rem Next line of code was needed to solve an unexplained issue where the previous LoC resulted
	Rem in the HI cell getting error #NAME? (code 525). It "works" for now...
   	dateCell.FormulaLocal = newDate
End Sub

