use starknet::ContractAddress;
use use starknet::get_caller_address;
use array::ArrayTrait;


#[starknet::interface]
trait DatabaseTrait<T> {
    fn display_books(self:@T)->felt252;

    //fn add_books()
}

#[starknet::contract]
mod add_book {

    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[derive(Drop,Copy,Serde,starknet::Store)]
    struct Book{
        Title:felt252;
    }

    //This is the structure that stores all variables i.e the various types of books
    #[storage]
    struct Storage {
        Books:Array<Book>;
    }


    #[constructor]

    let book1 = Book{Title:'Be Rich',};
    let book2 = Book{Title:'1000 ways',};

    fn constructor(ref self:ContractState,book1:Book,book2:Book){
        self.add_book(book1,book2)
    }

    #[external(v0)]
    impl DatabaseTraitImp of super::DatabaseTrait<ContractState>{

        fn display_books(self:@ContractState){

            let mut arr = @ArrayTrait::<Book>::new();

            arr = self.Books;

            let len = arr.len();

            let mut i:usize = 0;

            loop{
                 if len <=i{
                    break;
                }
                let mut books:Book = *arr.at(i);
                books.book_title_display();
                i+=1;
            }

        }

    }

}
