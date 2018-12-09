
#include <stdio.h>
#include <iostream>
#include <cstdint>
#include <vector>
#include  <fstream>
#include <cmath>

using namespace std;
/*
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long uint32_t;
typedef unsigned long long uint64_t;
*/
void print_4_bytes(vector<unsigned char>::iterator &iter)
{
  cout <<  ((static_cast<uint32_t>(*(iter+3)) << 24)
    | (static_cast<uint32_t>(*(iter+2)) << 16)
    | (static_cast<uint32_t>(*(iter+1)) << 8)
    | (static_cast<uint32_t>(*iter))) << endl;
    iter+=4;
}

void print_2_bytes(vector<unsigned char>::iterator &iter)
{
  cout <<  ((static_cast<uint32_t>(*(iter+1)) << 8)
    | (static_cast<uint32_t>(*(iter)))) << endl;
    iter+=2;
}


int read_n_bytes(ifstream &f, size_t n, vector<unsigned char> &bytes)
{

  for(size_t i=0; i < n; ++i)
  {
      unsigned char byte;

      f >> byte;

      if (f.fail())
      {
          cout << "failed to read from file\n";
          return 1;
      }

      bytes.push_back(byte);
    }
  return 0;
}

int main(void)
{
  ifstream f;
  f.open("/home/marcel/Documents/ARKO/trajectory.bmp", ios::binary);
  if (f.fail())
  {
    cout << "failed to open the file\n";
      return 1;
  }
  vector<unsigned char> bytes;
  //header
  if (read_n_bytes(f, 14, bytes))
  {
    cout << "error occured\n";
      return 0;
  }
  vector<unsigned char>::iterator it = bytes.begin();

  cout << *it << endl;
  cout <<*(++it) << endl;
  ++it;
  print_4_bytes(it);
  it +=4; // nieznaczące

	it = bytes.begin()+10;
  cout << "offset = ";
  print_4_bytes(it);
  cout << "*****end of file header*****\n";
  //DIB header
  if (read_n_bytes(f, 40, bytes))
  {
    cout << "error occured\n";
      return 0;
  }
  it = bytes.begin();
  it+=14;
  cout << "dlugosc naglowka = ";
  print_4_bytes(it);
  cout << "image width = ";
  print_4_bytes(it);
  cout << "image height: ";
  print_4_bytes(it);
  it = bytes.begin();
  it+=26;
  cout << "n warstw kolorow: ";
  print_2_bytes(it);
  cout << "bits per pixel: ";
  print_2_bytes(it);
  cout << "compression algorithm: ";
  print_4_bytes(it);
  cout << "image only size: ";
  print_4_bytes(it);
  cout << "rozdzielczosc pozioma = ";
  print_4_bytes(it);
  cout << "rozdzielczosc pionowa = ";
  print_4_bytes(it);
  cout << "colors used: ";
  print_4_bytes(it);
  cout << "end of DIB header\n";
  it = bytes.begin();
  it+=1078;
  /*
  if (read_n_bytes(f, 500, bytes))
  {
    cout << "error occured\n";
      return 0;
  }
  cout << "**pixel array started**\n";
  cout << "B\tG\tR\n";
  for(size_t i=0; i < 100 ; ++i)
  {
    cout << (int)*it<<'\t' << (int)*(++it) << "\t" << (int)*(++it) << endl;
  }

  */
  f.close();
  return 0;
}
