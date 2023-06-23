create or replace function 
	add_teacher (the_firstname text, the_lastname text, the_email text )
	returns boolean as
$$
declare
-- declare a variable to be used in the function
total int;

begin

	-- run a query to check if the teachers' name exists
	select into total count(*) from teacher 
		where LOWER(email) = LOWER(the_email);

	-- if total is 0 the teacher doesn't exist
	if (total = 0) then
		-- then create the teacher
		insert into teacher (first_name, last_name, email) values (the_firstname, the_lastname, the_email);
		-- and returns true if the teacher was created already
		return true;
	else
		-- returns false if the teacher already exists
		return false;
	end if;

end;
$$
Language plpgsql;

------------------------------------------------------------------------------------------

create or replace function 
	link_teacher_to_subject (the_teacherId int, the_subjectId int)
	returns boolean as
$$
declare
-- declare a variable to be used in the function
total int;

begin

	-- run a query to check if the teachers' name exists
	select into total count(*) from teacher_subject
		where (teacher_id) = (the_teacherId);

	-- if total is 0 the teacher doesn't exist
	if (total = 0) then
		-- then create the teacher
		insert into teacher_subject (teacher_id, subject_id) values (the_teacherId, the_subjectId );
		-- and returns true if the subject is linked to a teacher
		return true;
	else
		-- returns false if the teacher is already linked to a subject 
		return false;
	end if;

end;
$$
Language plpgsql;
--------------------------------------------------------------------------------
create or replace function 
	find_teachers_for_subject (
	
	the_subject text
	
	)
	
	returns table (
	
	the_teacherForSubject text
	
	)as 
$$

begin

	-- run a query to return the teachers' name
	return query
	select teacher.first_name from teacher_subject
	 join teacher on teacher.id = teacher_subject.teacher_id
	 join subject on subject.id = teacher_subject.subject_id
		where LOWER(subject.name) = LOWER(the_subject);

end;
$$
Language plpgsql;
----------------------------------------------------------------------
create or replace function 
	find_teachers_teaching_multiple_subjects (
	
	the_numberOfSubject int
	
	)
	
	returns table (
	
	the_teacher text
	
	)as 
$$

begin


	return query
	select teacher.first_name from teacher_subject
	 join teacher on teacher.id = teacher_subject.teacher_id
	 join subject on subject.id = teacher_subject.subject_id
		group by teacher.first_name
		having count(teacher_subject.subject_id) = the_numberOfSubject;

end;
$$
Language plpgsql;
