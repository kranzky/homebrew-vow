class Vow < Formula
  desc "Programming language for machine authors, with contracts proved by Z3"
  homepage "https://vow.kranzky.com"
  url "https://github.com/kranzky/vow/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "cc7e5b2ab3d758f5514813c8f28d908fe91daf1a2de4db8380b8447bc08511b1"
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
