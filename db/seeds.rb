require 'factory_bot_rails'


ad1 = FactoryBot.create(:admin_user, email: 'admin1@gmail.com', name: 'Carlos Anriquez')
ad2 = FactoryBot.create(:admin_user, email: 'admin2@gmail.com', name: 'Cecilia Fernandez')
        
u1 = FactoryBot.create(:user_user, email: 'email3@gmail.com', avatar: 'https://anri-img-storage.s3.amazonaws.com/avatar/u1.png', name: 'Hannibal Luch')
u2 = FactoryBot.create(:user_user, email: 'email4@gmail.com', avatar: 'https://anri-img-storage.s3.amazonaws.com/avatar/u2.png', name: 'Clara Branch')
u3 = FactoryBot.create(:user_user, email: 'email5@gmail.com', avatar: 'https://anri-img-storage.s3.amazonaws.com/avatar/u3.png', name: 'Sylvia Commit')
u4 = FactoryBot.create(:user_user, email: 'email6@gmail.com', avatar: 'https://anri-img-storage.s3.amazonaws.com/avatar/u4.png', name: 'Carolyn Format')
u5 = FactoryBot.create(:user_user, email: 'email7@gmail.com', avatar: 'https://anri-img-storage.s3.amazonaws.com/avatar/u5.png', name: 'Pedro Syntax')
u6 = FactoryBot.create(:user_user, email: 'email8@gmail.com', avatar: 'https://anri-img-storage.s3.amazonaws.com/avatar/u6.png', name: 'Jhonny Fastkeys')
u7 = FactoryBot.create(:user_user, email: 'email9@gmail.com', avatar: 'https://anri-img-storage.s3.amazonaws.com/avatar/u8.png',, name: 'Lissa Learner')
    
jb1 = FactoryBot.create(:jobpost, author: ad1, name:'Information Technology Intern')
jb2 = FactoryBot.create(:jobpost, author: ad1, name:'Digital Marketing Intern' )
jb3 = FactoryBot.create(:jobpost, author: ad2, name:'Human Resources Intern')
jb4 = FactoryBot.create(:jobpost, author: ad2, name:'Sales Intern')
    
app1 = FactoryBot.create(:application, jobpost: jb1, applicant_id: u1.id)
app2 = FactoryBot.create(:application, jobpost: jb1, applicant_id: u2.id)
app3 = FactoryBot.create(:application, jobpost: jb1, applicant_id: u3.id)

app4 = FactoryBot.create(:application, jobpost: jb2, applicant_id: u4.id)

app5 = FactoryBot.create(:application, jobpost: jb3, applicant_id: u5.id)

app6 = FactoryBot.create(:application, jobpost: jb4, applicant_id: u6.id)

app7 = FactoryBot.create(:application, jobpost: jb4, applicant_id: u7.id)
app8 = FactoryBot.create(:application, jobpost: jb3, applicant_id: u6.id)
app9 = FactoryBot.create(:application, jobpost: jb3, applicant_id: u4.id)

#likes for admin1
lk1 = FactoryBot.create(:like, evaluation: 'like', application_id: app1.id, admin_id: ad1.id)
lk2 = FactoryBot.create(:like, evaluation: 'dislike', application_id: app2.id, admin_id: ad1.id)
lk3 = FactoryBot.create(:like, evaluation: 'like', application_id: app3.id, admin_id: ad1.id)
lk4 = FactoryBot.create(:like, evaluation: 'like', application_id: app4.id, admin_id: ad1.id)
lk5 = FactoryBot.create(:like, evaluation: 'like', application_id: app5.id, admin_id: ad1.id)

#likes for admin2
lk6 = FactoryBot.create(:like, evaluation: 'dislike', application_id: app1.id, admin_id: ad2.id)
lk7 = FactoryBot.create(:like, evaluation: 'dislike', application_id: app2.id, admin_id: ad2.id)
lk8 = FactoryBot.create(:like, evaluation: 'dislike', application_id: app3.id, admin_id: ad2.id)
lk9 = FactoryBot.create(:like, evaluation: 'like', application_id: app4.id, admin_id: ad2.id)
lk10 = FactoryBot.create(:like, evaluation: 'like', application_id: app5.id, admin_id: ad2.id)
lk11 = FactoryBot.create(:like, evaluation: 'like', application_id: app6.id, admin_id: ad2.id)
lk12 = FactoryBot.create(:like, evaluation: 'like', application_id: app7.id, admin_id: ad2.id)
