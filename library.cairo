use debug::PrintTrait;

//These are the two types of user who can access the database i.e Admins and students
#[derive(Copy, Drop, )]
enum Users  {
    Admin: felt252,
    Student:felt252,
}


fn which_user(users:Users)->felt252{

    match users{
        Users::Admin(value1)=>{
            'Chose Admin'.print();
            1
            
        },

        Users::Student(value2)=>{
            'Chose Student'.print();
            2
            
        }
    }


}

fn main(){
    let greeting = 'Hello Log in as:- ';

    greeting.print();

    ('1.Admin').print();

    ('2.Student').print();


    which_user(Users::Student(2));

    // which_user(Users::Admin(1));




}
