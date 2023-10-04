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
    fn book_title_display(self:@Book)->felt252;
}

impl BookTraitImpl of BookTrait{
    fn book_title_display(self:@Book)->felt252{
        let mut Title=*self.Title;
        Title
    }
}
//Database to store array of books
#[derive(Drop)]
struct Database{
    Books:Array<Book>,
}


trait DatabaseTrait{
    fn display_books(self:@Database);

    fn add_book(self:@Database,book:Book);

    fn search_book(self:@Database,Title:felt252)->bool;
}

impl DatabaseTraitImpl of DatabaseTrait{
    fn display_books(self:@Database){
        let mut arr = ArrayTrait::new();
        arr = *self.Books;
        let len = arr.len();

        let mut i:usize = 0;
        
        loop{
            if len <=i{
                break;
            }
            let mut books:Book = *self.Books[i];
            books.book_title_display();
            i+=1;
        }


    }

    fn add_book(self:@Database,book:Book){
       let mut arr = *self.Books;
       arr.append(book);

    }

    fn search_book(self:@Database,Title:felt252)->bool{

        let mut i = 0;
        loop{                     //--available-gas=20000000 don't forget to pass this when using loops in Cairo
            let mut booksrch:Book = *self.Books[i];

            if booksrch.Title == Title{
                'Book Available'.print();
                Title.print();
                booksrch.Year.print();
                booksrch.Genre.print();
                let mut availability:bool= true;
                availability;
                break;
            }
            i+=1;
        };
        'Book not found'.print();
        let mut availability:bool=false;
        availability
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
