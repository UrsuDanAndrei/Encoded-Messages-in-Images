#include <iostream>
#include <string>
#include <vector>
#include <fstream>

std::ifstream fin1 ("~/Desktop/file.out");
std::ifstream fin2 ("~/Desktop/file.ref");

int main()
{
	std::vector<int> v1;
	std::vector<int> v2;

	int n, m;
	std::string s;
	fin1 >> s;
	fin1 >> n >> m;

	fin2 >> s;
	fin2 >> n >> m;

	for (int i = 0; i < n * m; ++i) {
		int x, y;
		fin1 >> x;
		fin2 >> y;

		v1.push_back(x);
		v2.push_back(y);

		if (x != y) {
			std::cout << "x: " << x << " y: " << y << " ";
			std::cout << i << " " << i / m << " " << i % m << std::endl;
		}
	}
	return 0;
}