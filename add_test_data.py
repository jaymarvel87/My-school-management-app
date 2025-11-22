from django.contrib.auth.models import User, Group
from django.contrib.auth import get_user_model
from school.models import Student, Teacher, ParentProfile, ClassModel, Meeting
from django.utils import timezone
from datetime import timedelta

User = get_user_model()

# Create groups (idempotent)
teacher_group, _ = Group.objects.get_or_create(name='teacher')
student_group, _ = Group.objects.get_or_create(name='student')
parent_group, _ = Group.objects.get_or_create(name='parent')

# Teacher (skip if exists)
teacher_user, created = User.objects.get_or_create(username='teacher', defaults={'email': 'teacher@example.com', 'password': 'pbkdf2_sha256$390000$abc$hash123'})
if created:
    teacher_user.set_password('pass123')
    teacher_user.save()
teacher, _ = Teacher.objects.get_or_create(user=teacher_user, defaults={'subject': 'Math'})
teacher_user.groups.add(teacher_group)

# Student
student_user, created = User.objects.get_or_create(username='student', defaults={'email': 'student@example.com', 'password': 'pbkdf2_sha256$390000$def$hash456'})
if created:
    student_user.set_password('pass123')
    student_user.save()
stud, _ = Student.objects.get_or_create(user=student_user, defaults={'grade_level': 'Grade 10', 'student_id': 'STU001'})
student_user.groups.add(student_group)

# Parent
parent_user, created = User.objects.get_or_create(username='parent', defaults={'email': 'parent@example.com', 'password': 'pbkdf2_sha256$390000$ghi$hash789'})
if created:
    parent_user.set_password('pass123')
    parent_user.save()
prof, _ = ParentProfile.objects.get_or_create(user=parent_user, defaults={'student': stud, 'phone': '1234567890'})
parent_user.groups.add(parent_group)

# Class
cls, _ = ClassModel.objects.get_or_create(name='Test Class', defaults={'grade_level': 'Grade 10', 'teacher': teacher})
if not cls.students.filter(id=stud.id).exists():
    cls.students.add(stud)

# Sample Meeting (create if not exists)
if not Meeting.objects.filter(title='Test Meeting').exists():
    Meeting.objects.create(
        title='Test Meeting',
        student=stud,
        parent=prof,
        date=timezone.now() + timedelta(days=1),
        notes='Test notes'
    )

print("Test data added/updated! Users: teacher/pass123, student/pass123, parent/pass123")
print("Groups assigned; Class linked; Sample meeting created/verified.")
