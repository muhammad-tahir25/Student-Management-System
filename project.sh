
# Showing Welcome Screen
echo -e "\n\t\t<------------------------------------------------------- { } ------------------------------------------------------------->"
echo -e "\n\t\t\t\t\t< ============ WELCOME TO STUDENT MANAGEMANT SYSTEM (SMS) =========== >\n"
echo -e "\t\t<------------------------------------------------------- { } ------------------------------------------------------------->"



echo -e "\n"

# Showing Main Menu for USER to perform operations
main_menu(){

echo -e "\n   === Who's there? ==="
echo "   1. Teacher"		
echo "   2. Student"
echo -e "   3. Exit\n"
return 0
}


# This will check the alloted password is correct or not
check_Teacher_Password(){
if [[ $1 == 12345 ]]
then
   echo -e "\nCorrect Password"
   return 0
   
else
 echo -e "\nIncorrect Password\nHint: 45"	# if there is wrong password enterd, then hint will be shown
 return 1
fi
}



# This is only for teacher operations when he/she logs in and then perform desired operations, all data stored/retrieval from file system
Teacher_Operations(){
 
 echo -e "\n   1. Add Student"
 echo "   2. Delete Student"
 echo "   3. Assign Marks"
 echo "   4. Calculate Grade"
 echo "   5. Calculate CGPA"
 echo "   6. Search the student"
 echo "   7. List Passed Students"
 echo "   8. List Failed Students"
 echo "   9. Display Students"
 echo -e "   10. List of Students (Asscending & Descending according to CGPA)\n"
 read -p "Please choose an option: " a
 echo -e "\n"
      case $a in
      
      	1)
      	  
      	  add_student	# calling fucntion for addition of student to record
      	   
      	;;
      	
      	2)
      	  Delete_student		# delete student from all files
      	
      	;;
      	
      	3)
      	  Assign_Marks	 	# Update the marks of student
      	;;
      	
      	4)
      	  calculate_grade		# this will calculate the grades for all students according to subject marks
      	;;
      	
      	5)
      	  calculate_CGPA		# this will calculate the CGPA for all students according to Grades
      	;;
      	
      	6)
      	  search_student		# search student by inputing roll no
      	;;
      	
      	7)
      	  list_passed_students	# get students of cgpa >= 2.00
      	;;
      	
      	8)
      	  list_failed_students	# get students of cgpa < 2.00
      	;;
      	
      	9)
      	  display_students		# show all students subject wise marks,  grades and cgpa
      	 ;;
      	
      	10)
      	  list_ASC_DESC		# listing students in Ascending and Descending order
      	;;
      	
          *)
           echo -e "Invalid choice!\n"
          ;;
      esac
}



# This will add data of new student to record.txt file
add_student() {

    read -p "Enter student Roll No: " b
    read -p "Enter student name: " c
    read -p "Enter PF marks: " d
    read -p "Enter OOP marks: " e
    read -p "Enter OS marks: " f
    read -p "Enter DBS marks: " g
    read -p "Enter Prob marks: " h

    if [ -f "record.txt" ]; then		# Checking if file is existing or not
        if grep -q "^$b" record.txt; then
            echo -e "Same roll no found. Cannot Insert Record!\n"
            return 0
        fi
        
	# Adding record to file using operator >>
        echo -e "$b\t$c\t$d\t$e\t$f\t$g\t$h" >> record.txt
        echo -e "Record Added Successfully\n"

    else
        echo "Record File does not exist"
    fi
}



# Delete all record of a student from all files
Delete_student() {

read -p "Enter the roll no of student to delete it: " a	  # Prompting enter roll no of student to delete record		

if [ -f "record.txt" ] && [ -f "grades.txt" ] && [ -f "cgpa_result.txt" ]
then
     if grep -q "^$a" record.txt
       then
       # Deleting from all three files of record, grades and cgpa_result files
         sed -i "/^$a/d" record.txt
         sed -i "/^$a/d" grades.txt
         sed -i "/^$a/d" cgpa_result.txt
         echo -e "Student with roll no. $a deleted successfully!\n"
         
     else
         echo -e "Student with roll no. $a not found!\n"
     fi
else
  echo "Record File does not exist"
fi

}


# This will update data of student with new one
Assign_Marks() {
    read -p "Enter the roll number of the student to assign marks: " roll_no

    if [ -f "record.txt" ]; then
        if grep -q "^$roll_no" record.txt; then
            get_record=$(grep "^$roll_no" record.txt)
            echo -e "\n******* Current Record: *******"		# This will show old data first and then add new data to files
            echo -e "Roll_no\t\tName\t\tPF\tOOP\tOS\tDBS\tPROB"
            echo "----------------------------------------------------------------------"
            echo "$get_record"
            echo -e "\n"

            # Ask for the new marks for each subject
            read -p "Enter new PF marks: " new_pf
            read -p "Enter new OOP marks: " new_oop
            read -p "Enter new OS marks: " new_os
            read -p "Enter new DBS marks: " new_dbs
            read -p "Enter new Probability marks: " new_prob

            # Update the record file with new marks
            sed -i "/^$roll_no/s/[0-9]\+\t[0-9]\+\t[0-9]\+\t[0-9]\+\t[0-9]\+/$new_pf\t$new_oop\t$new_os\t$new_dbs\t$new_prob/" record.txt
            
	  # After updating data, funtions of calulating grades and cgpa will be called automatically to show updated versions
	  calculate_grade
	  calculate_CGPA
	  
            echo -e "Marks updated successfully!"
        else
            echo -e "Student with roll number $roll_no not found!\n"
        fi
    else
        echo "Record File does not exist"
    fi
}



# This function is calculating & assigning grades according to absolutes obtained
assign_grade() {
    if [[ $1 -lt 0 || $1 -gt 100 ]]; then
        echo "Invalid Marks"
    elif [[ $1 -ge 95 ]]; then
        echo "A+"
    elif [[ $1 -ge 90 ]]; then
        echo "A"
    elif [[ $1 -ge 85 ]]; then
        echo "A-"
    elif [[ $1 -ge 80 ]]; then
        echo "B+"
    elif [[ $1 -ge 75 ]]; then
        echo "B"
    elif [[ $1 -ge 70 ]]; then
        echo "B-"
    elif [[ $1 -ge 65 ]]; then
        echo "C+"
    elif [[ $1 -ge 60 ]]; then
        echo "C"
    elif [[ $1 -ge 55 ]]; then
        echo "C-"
    elif [[ $1 -ge 50 ]]; then
        echo "D"
    else
        echo "F"
    fi
}




calculate_CGPA() {
    if [ -f "grades.txt" ]; then
        echo -e "CGPA Calculation in Progress...\n"

        > cgpa_result.txt  	# This is overwriting data with new one 

        while IFS=$'\t' read -r roll_no name pf_grade oop_grade os_grade dbs_grade prob_grade; do
        
            # Calculate CGPA using the function cal_gpa
            cgpa=$(cal_gpa "$pf_grade" "$oop_grade" "$os_grade" "$dbs_grade" "$prob_grade")

            # Append result to cgpa_result.txt
            echo -e "$roll_no\t$name\t$pf_grade\t$oop_grade\t$os_grade\t$dbs_grade\t$prob_grade\t$cgpa" >> cgpa_result.txt

        done < grades.txt

        echo -e "CGPA calculated for all students.\n"
    else
        echo "grades File Does Not Exist. Run 'calculate_grade' first."
    fi
}





# It is calculating gpa and returing to function
cal_gpa(){

total_gpa=0
count=0

for grade in "$@"
do
  case $grade in
   "A+") gp=4.0 ;;
   "A")  gp=4.0 ;;
   "A-") gp=3.67 ;;
   "B+") gp=3.33 ;;
   "B")  gp=3.0 ;;
   "B-") gp=2.67 ;;
   "C+") gp=2.33 ;;
   "C")  gp=2.0 ;;
   "C-") gp=1.67 ;;
   "D+") gp=1.33 ;;
   "D")  gp=1.0 ;;
   "F")  gp=0.0 ;;
   *)    gp=0.0 ;;
   
   esac
   
   # formula of cgpa
  total_gpa=$(echo "$total_gpa + ($gp * 3)" | bc)
  ((count++))
done

if [[ "$count" -gt 0 ]]
 then
 
 # Limiting cgpa upto 2 decimal points like 3.03
     cgpa=$(echo "scale=2; $total_gpa / ($count * 3)" | bc)
        echo "$cgpa"
    else
        echo "0.00"
    fi

}




# This is retriving marks from file record and calulating grades of it then saving grades into new file named grades.txt
calculate_grade() {
    if [ -f "record.txt" ]; then
    
        # Clear result.txt before writing new data
        > grades.txt  
        
        while IFS=$'\t' read -r roll_no name pf oop os dbs prob; do
            if [[ "$roll_no" == "roll_no" ]]; then
                continue
            fi
            
            pf_grade=$(assign_grade "$pf")
            oop_grade=$(assign_grade "$oop")
            os_grade=$(assign_grade "$os")
            dbs_grade=$(assign_grade "$dbs")
            prob_grade=$(assign_grade "$prob")

            # Append the results to result.txt
            echo -e "$roll_no\t$name\t$pf_grade\t$oop_grade\t$os_grade\t$dbs_grade\t$prob_grade" >> grades.txt
        done < record.txt

        echo -e "Grades have been assigned to students.\n"
    else
        echo "Error: grades.txt file not found."
    fi
}




# This will search of student by roll no from files using grep and displaying
search_student() {
    read -p "Enter the roll no of student to search: " rollno
    echo -e "\n"
    
    # Check if record.txt exists
    if [ ! -f "record.txt" ]; then
        echo "Error: 'record.txt' file not found!"
        return 1
    fi

    # Search for student in record.txt
    student_record=$(grep "^$rollno" record.txt)
    if [ -n "$student_record" ]; then
       
       echo -e "Roll_no\t\tName\t\tPF\tOOP\tOS\tDBS\tPROB"
     echo "----------------------------------------------------------------------"
        echo -e "$student_record"
    else
        echo -e "Student with roll no. $rollno not found in 'record.txt'!\n"
    fi

    # Check if cgpa_result.txt exists
    if [ ! -f "cgpa_result.txt" ]; then
        echo "Error: 'cgpa_result.txt' file not found!"
        return 1
    fi

    # Search for student in cgpa_result.txt
    student_cgpa=$(grep "^$rollno" cgpa_result.txt)
    if [ -n "$student_cgpa" ]; then
      
        echo -e "\n\nRoll_no\t\tName\t\tPF\tOOP\tOS\tDBS\tPROB\tCGPA"
     echo  "------------------------------------------------------------------------------"
        echo -e "$student_cgpa"
    else
        echo -e "Student with roll no. $rollno not found in 'cgpa_result.txt'!\n"
    fi
    
    echo -e "\n"
}





# It is showing passed students of cgpa >= 2.00
list_passed_students() {

# Displaying the header for the list of passed students
    echo -e "=> The list of passed students are:\n"
    echo -e "Roll_no   \t\tName\t\t\tPF_grade\tOOP_grade\tOS_grade\tDBS_grade\tPROB_grade\tCGPA"
    echo -e "--------------------------------------------------------------------------------------------------------------------------------------\n"

    if [ ! -f "cgpa_result.txt" ]; then		 # Error message if the file is missing
        echo "Error: 'cgpa_result.txt' file not found!"
        return 1
    fi

    passed_students=0	# Variable to count the number of passed students
    
    
    # Reading the file line by line with tab-separated values
    while IFS=$'\t' read -r roll_no name pf_grade oop_grade os_grade dbs_grade prob_grade cgpa; do
    
        # Ensure CGPA is numeric before comparison
        if [[ "$cgpa" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            if (( $(echo "$cgpa >= 2.00" | bc -l) )); then
                echo -e "$roll_no\t\t$name\t\t$pf_grade\t\t$oop_grade\t\t$os_grade\t\t$dbs_grade\t\t$prob_grade\t\t$cgpa"
                ((passed_students++))
            fi
        
        fi
    done < cgpa_result.txt	# Input file for reading student data

    if [ "$passed_students" -eq 0 ]; then
    echo -e "\nNo students passed.\n"
    else
    	echo -e "\nNo. of students passed: $passed_students\n"
    fi

}




# It is showing failed students of cgpa < 2.00
list_failed_students(){

# Displaying the header for the list of passed students
    echo -e "=> The list of failed students are:\n"
    echo -e "Roll_no   \t\tName\t\t\tPF_grade\tOOP_grade\tOS_grade\tDBS_grade\tPROB_grade\tCGPA"
    echo -e "--------------------------------------------------------------------------------------------------------------------------------------\n"

    if [ ! -f "cgpa_result.txt" ]; then		# Error message if the file is missing
        echo "Error: 'cgpa_result.txt' file not found!"
        return 1
    fi

    failed_students=0
    
    
# Reading the file line by line with tab-separated values

    while IFS=$'\t' read -r roll_no name pf_grade oop_grade os_grade dbs_grade prob_grade cgpa; do
    
        # Ensure CGPA is numeric before comparison
        if [[ "$cgpa" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            if (( $(echo "$cgpa < 2.00" | bc -l) )); then
                echo -e "$roll_no\t\t$name\t\t$pf_grade\t\t$oop_grade\t\t$os_grade\t\t$dbs_grade\t\t$prob_grade\t\t$cgpa"
                ((failed_students++))
            fi
        
        fi
    done < cgpa_result.txt		# Input file for reading student data

    if [ "$failed_students" -eq 0 ]; then
    echo -e "\nNo students failed.\n"
    else
    	echo -e "\nNo. of students failed: $failed_students\n"
    fi

}




# Showing record separately marks and then grades with cgpa
display_students(){

echo -e "------------------"
echo "-> Marks Record is:"
echo -e "------------------\n\n"

# Displaying column headers for student marks

echo -e "Roll_no   \t\tName\t\t\tPF_marks\tOOP_marks\tOS_marks\tDBS_marks\tPROB_marks"
echo -e "---------------------------------------------------------------------------------------------------------------------------\n"
    
    # Checking if the file 'record.txt' exists
 if [ ! -f "record.txt" ]; then
        echo "Error: 'record.txt' file not found!"
        return 1
 fi

 # Reading the file line by line and extracting student marks
	while IFS=$'\t' read -r roll_no name pf_grade oop_grade os_grade dbs_grade prob_grade 
   	 do
        		echo -e "$roll_no\t\t$name\t\t$pf_grade\t\t$oop_grade\t\t$os_grade\t\t$dbs_grade\t\t$prob_grade"
        
    	done < record.txt

echo -e "\n"


    if [ ! -f "cgpa_result.txt" ]; then
        echo "Error: 'cgpa_result.txt' file not found!"
        return 1
    fi
    
    # Displaying a header for the transcript record
echo -e "----------------------"
echo "-> Transcript Record is:"
echo -e "----------------------\n\n"

echo -e "Roll_no   \t\tName\t\t\tPF_grade\tOOP_grade\tOS_grade\tDBS_grade\tPROB_grade\tCGPA"
echo -e "--------------------------------------------------------------------------------------------------------------------------------------\n"

 # Reading the file line by line and extracting student transcripts
	while IFS=$'\t' read -r roll_no name pf_grade oop_grade os_grade dbs_grade prob_grade cgpa
   	 do
        		echo -e "$roll_no\t\t$name\t\t$pf_grade\t\t$oop_grade\t\t$os_grade\t\t$dbs_grade\t\t$prob_grade\t\t$cgpa"
        
    	done < cgpa_result.txt
}




list_ASC_DESC() {
    if [ ! -f "cgpa_result.txt" ]; then
        echo "Error: 'cgpa_result.txt' file not found!"
        return 1
    fi

    echo "----------------------------------------"
    echo "-> List of students in Ascending order:"
    echo "----------------------------------------"
    echo -e "\nRoll_no\t\tName\t\tPF\tOOP\tOS\tDBS\tPROB\tCGPA"
    echo "-------------------------------------------------------------------------------"

    # Sorting the file based on the 8th column (CGPA) in ascending order
    # -t$'\t'  → Specifies that fields in the file are tab-separated
    # -k8,8n   → Sorts based on the 8th column (CGPA) in numerical order (`n` flag ensures numerical comparison)
    sort -t$'\t' -k8,8n cgpa_result.txt






    echo -e "\n----------------------------------------"
    echo "-> List of students in Descending order:"
    echo "----------------------------------------"
    echo -e "\nRoll_no\t\tName\t\tPF\tOOP\tOS\tDBS\tPROB\tCGPA"
    echo "------------------------------------------------------------------------------"

    # Sorting the file based on the 8th column (CGPA) in descending order
    # -t$'\t'  → Specifies tab as the field separator
    # -k8,8nr  → Sorts based on the 8th column (CGPA) in reverse (`r` flag for descending) and numerical order (`n`)
    sort -t$'\t' -k8,8nr cgpa_result.txt

}




# Now student is performing operations, he/she can only view grades, cgpa using roll no as a password

Student_Operations(){
    echo -e "\n   === Student Menu ==="
    echo "   1. View Grades"
    echo "   2. View CGPA"
    echo -e "   3. Back to Main Menu\n"
    read -p "Please choose an option: " choice
    
    case $choice in
        1) view_grades 
        ;;
        
        2) view_CGPA 
        ;;
        
        3) 
        return 
        ;;
        
        *) echo -e "Invalid choice!\n" ;;
    esac
}


# retrieving grades from file grade using grep func

view_grades(){
    read -p "Enter your Roll No: " roll_no
    
    echo -e "\n"
    
    echo -e "Roll_no\t\tName\t\tPF\tOOP\tOS\tDBS\tPROB"
     echo "----------------------------------------------------------------------"
    
    if [ -f "grades.txt" ]; then
        grep "^$roll_no" grades.txt || echo "No record found!"
    else
        echo "Error: 'grades.txt' file not found!"
    fi
    
    echo -e "\n"
}


# retrieving cgpa from file cgpa_result using grep func
view_CGPA() {
    read -p "Enter your Roll No: " roll_no
    
    echo -e "\n"
    if [ -f "cgpa_result.txt" ]; then
        result=$(grep "^$roll_no" cgpa_result.txt)
        if [ -n "$result" ]; then
            name=$(echo "$result" | awk '{print $2, $3}')
            cgpa=$(echo "$result" | awk '{print $NF}')
            echo -e "Roll No: $roll_no\nName: $name\nCGPA: $cgpa"
        else
            echo "No record found!"
        fi
    else
        echo "Error: 'cgpa_result.txt' file not found!"
    fi
}



# This will calling main menu until is called exit
n=0
while [[ $n -ne 3 ]]
do
 
   main_menu
   read -p "Please select 1 option: " n

   case $n in

    	1)
   	 	echo -e "\n<---- Welcome Teacher! ---->"
   	 	read -p "Please Enter Password: " a
   	 	
   	 	if check_Teacher_Password $a
   	 	then
   	   	echo -e "Access Granted!\n"
   	  
   	   	Teacher_Operations   	# calling teachers menu operations function
   	   	
   	 	else
   	   	echo "Access Denied!\n"
   	 	fi
    	;;
    	
    	2)
    	  echo -e "\n<---- Welcome Student! ---->"
    	  
            Student_Operations		# calling students menu operations function
            
    	;;
    	
    	3)
   	echo -e "\n*** Good Bye, FOLK! ***"
   	
	echo -e "\nToday's Date: $(date +"%Y-%m-%d")"		# printing current date from pc
	echo  -e "Current Time: $(date +"%H:%M:%S")\n"		# printing current time from pc
   	exit
   	;;
   	
  	*)
  	echo "Invalid input!"
  	;;
  	
   esac
done

