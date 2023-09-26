use debug::PrintTrait;
use array::ArrayTrait;
use option::OptionTrait;
//These are the two types of user who can access the database i.e Admins and students
#[derive(Copy, Drop, )]
enum Users  {
    Admin: felt252,
    Student:felt252,
}


//This is the function which when called grants different rights to the different users
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

#[derive(Copy,Drop)]
struct Book{
    Title:felt252,
    Genre:felt252,
    Year:u256,
}

trait BookTrait{
    fn book_title_display(@self:Book)
}

imp BookTraitImpl of BookTrait{
    fn book_title_display(@self){
        *self.Title.print();
    }
}
//Database to store array of books
#[derive(Drop)]
struct Database{
    Books:Array<Book>,
}


trait DatabaseTrait{
    fn display_books(self:@Database);
}

impl DatabaseTraitImpl of DatabaseTrait{
    fn display_book(self:@Book){
        let len = self.Books.len();

        let mut i:usize = 0;
        
        loop{
            if i>
        }


    }
}





fn main(){
    let greeting = 'Hello Log in as:- ';

    greeting.print();

    ('1.Admin').print();

    ('2.Student').print();


    which_user(Users::Student(4)); //Calling the chooser function

    // which_user(Users::Admin(1));


}
