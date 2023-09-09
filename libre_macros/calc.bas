REM  *****  BASIC  *****


Public oSheet As Object


Sub main()

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
	
	rowIndex = 2 ' Row 2
	maxRow = 12 ' no need to go further than row 14
	emptyCellFound = False
	
	Do While  rowIndex <= maxRow
		targetCell = oSheet.getCellByPosition(colIndex, rowIndex)
		If targetCell.getString() = "" Then
			emptyCellFound = True
			Exit Do
		End If
		rowIndex = rowIndex + 1
	Loop
	
	' If an empty cell is found, paste the value
	If emptyCellFound Then
		' msgbox valueToCopy & " " & colIndex
		targetCell.setValue(valueToCopy)
		Else
		MsgBox "No empty cell found in column(L=11) " & colIndex & " for value " & valueToCopy
	End If
End Sub

