class Book {
  int id;
  String title,
  writer,
  image,
  description;
  // description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
  int chapters;
  double rating; 

  Book(this.id, this.title, this.writer, this.image, this.description, this.chapters, this.rating);
}
String desc1 = "A Study in Scarlet is an 1887 detective novel by British author Arthur Conan Doyle. Written in 1886, the story marks the first appearance of Sherlock Holmes and Dr. Watson, who would become the most famous detective duo in popular fiction. The book's title derives from a speech given by Holmes, a consulting detective, to his friend and chronicler Watson on the nature of his work, in which he describes the story's murder investigation as his study in scarlet: There's the scarlet thread of murder running through the colourless skein of life, and our duty is to unravel it, and isolate it, and expose every inch of it.";
String desc6 = "The Memoirs of Sherlock Holmes (1893–94), Contains 12 stories published in The Strand as further episodes of the Adventures between December 1892 and December 1893 with original illustrations by Sidney Paget (after the magazine publication, Conan Doyle included The Adventure of the Cardboard Box only in the His Last Bow collection).";
String desc3 = "The Hound of the Baskervilles is the third of the four crime novels written by Sir Arthur Conan Doyle featuring the detective Sherlock Holmes. Originally serialised in The Strand Magazine from August 1901 to April 1902, it is set largely on Dartmoor in Devon in England's West Country and tells the story of an attempted murder inspired by the legend of a fearsome, diabolical hound of supernatural origin. Sherlock Holmes and his companion Dr. Watson investigate the case. This was the first appearance of Holmes since his apparent death in The Final Problem, and the success of The Hound of the Baskervilles led to the character's eventual revival";
String desc4 = "The Valley of Fear is the fourth and final Sherlock Holmes novel by Sir Arthur Conan Doyle. It is loosely based on the Molly Maguires and Pinkerton agent James McParland. The story was first published in the Strand Magazine between September 1914 and May 1915. The first book edition was copyrighted in 1914, and it was first published by George H. Doran Company in New York on 27 February 1915, and illustrated by Arthur I. Keller.";
String desc5 = "The Adventures of Sherlock Holmes (1892), Published 31 October 1892; contains 12 stories published in The Strand between July 1891 and June 1892 with original illustrations by Sidney Paget";
String desc2 = "The Sign of the Four (1890), also called The Sign of Four, is the second novel featuring Sherlock Holmes written by Sir Arthur Conan Doyle. Doyle wrote four novels and 56 short stories featuring the fictional detective.";
String desc7 = "The Return of Sherlock Holmes (1905) Contains 13 stories published in The Strand between October 1903 and December 1904 with original illustrations by Sidney Paget.";
String desc8 = "His Last Bow (1917) Contains 7 stories published 1908–1917. Many editions of His Last Bow have eight stories, with The Adventure of the Cardboard Box being a part of this collection rather than in The Memoirs of Sherlock Holmes";
String desc9 = "The Case-Book of Sherlock Holmes (1927) Contains 12 stories published 1921–1927.";


final List<Book> books = [
  Book(1, 'A Story In Scarlet', 'Conan Doyle', 'res/sherlock1.jpg', desc1, 14, 4.5),
  Book(2, 'The Sign of the Four', 'Conan Doyle', 'res/sherlock2.jpg', desc2, 12, 2.5),
  Book(3, 'The Hound of the Baskervilles', 'Conan Doyle', 'res/sherlock3.jpg', desc3, 15, 3.5),
  Book(4, 'The Valley of Fear', 'Conan Doyle', 'res/sherlock4.jpg',desc4,15, 5),
  Book(5, 'The Adventures of Sherlock Holmes', 'Conan Doyle', 'res/sherlock5.jpg', desc5,12, 4.5),
  Book(6, 'The Memoirs of Sherlock Holmes', 'Conan Doyle', 'res/sherlock6.jpg',desc6, 11, 4.5),
  Book(7, 'The Return of Sherlock Holmes', 'Conan Doyle', 'res/sherlock7.jpg',desc7, 13, 2.5),
  Book(8, 'His Last Bow	', 'Conan Doyle', 'res/sherlock8.jpg',desc8, 8, 3.5),
  Book(9, 'The Case-Book of Sherlock Holmes', 'Conan Doyle', 'res/sherlock9.jpg', desc9,12, 5),
];