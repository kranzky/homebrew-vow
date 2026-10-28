class Vow < Formula
  desc "Programming language for machine authors, with contracts proved by Z3"
  homepage "https://vow.kranzky.com"
  url "https://github.com/kranzky/vow/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "cfe901db603735feff3a7602f89374624bdd343e7ebae339baccf32ebb8f9bc4"
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
