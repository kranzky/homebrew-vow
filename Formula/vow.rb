class Vow < Formula
  desc "Programming language for machine authors, with contracts proved by Z3"
  homepage "https://vow.kranzky.com"
  url "https://github.com/kranzky/vow/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f4f061f5ad97c19280cafc87b9dc6b5aad2b7abf5dca39635d440b51330c5607"
  license "Unlicense"
  head "https://github.com/kranzky/vow.git", branch: "main"

  depends_on "z3"

  def install
    # Builds the compiler from its C seed; no other toolchain is needed.
    system "make"
    bin.install "build/vowc"
  end

  test do
    assert_match "vowc #{version}", shell_output("#{bin}/vowc version")
    (testpath/"hello.vow").write <<~VOW
      fn double(n: Int where it >= 0) -> Int
        ensures result >= n
      do
        return n + n
      end fn double

      fn main() uses console do
        print(int_to_str(double(21)) ++ "\\n")
      end fn main
    VOW
    assert_equal "42", shell_output("#{bin}/vowc run hello.vow").strip
  end
end
