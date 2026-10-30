class Vow < Formula
  desc "Programming language for machine authors, with contracts proved by Z3"
  homepage "https://vow.kranzky.com"
  url "https://github.com/kranzky/vow/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "74b3a86d6dee95368f774b988eaa3d0cc03e001ffe4f2b3d8c4e11291bb26ae2"
  license "Unlicense"
  head "https://github.com/kranzky/vow.git", branch: "main"

  depends_on "z3"

  def install
    # Builds the compiler from its C seed; no other toolchain is needed.
    system "make"
    # The language server is written in Vow: the new vowc verifies and builds it.
    system "make", "build/vow-lsp"
    bin.install "build/vowc", "build/vow-lsp"
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
