#include <iostream>
#include <vector>
#include <string>

int main() {
	std::string s = "A{.-} B{-...} C{-.-.} D{-..} E{.} F{..-.} G{--.} H{....} I{..} J{.---} K{-.-} L{.-..} M{--} N{-.} O{---} P{.--.} Q{--.-} R{.-.} S{...} T{-} U{..-} V{...-} W{.--} X{-..-} Y{-.--} Z{--..}";
	std::vector<int> begin;
	std::vector<int> end;

	for (int i = 0; i < s.size(); ++i) {
		if (s[i] == '{') {
			begin.push_back(i+1);
		}

		if (s[i] == '}') {
			end.push_back(i);
		}
	}

	std::cout << "begin: ";
	for (int i = 0; i < begin.size(); ++i) {
		std::cout << begin[i] << ", ";
	} 

	std::cout << std::endl;

	std::cout << "end: ";
	for (int i = 0; i < end.size(); ++i) {
		std::cout << end[i] << ", ";
	} 
	std::cout << std::endl;
	return 0;
}