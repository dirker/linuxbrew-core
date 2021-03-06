class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "http://cab.spbu.ru/files/release3.13.0/SPAdes-3.13.0.tar.gz"
  mirror "https://github.com/ablab/spades/releases/download/v3.13.0/SPAdes-3.13.0.tar.gz"
  sha256 "c63442248c4c712603979fa70503c2bff82354f005acda2abc42dd5598427040"

  bottle do
    cellar :any
    sha256 "1728c4d25e0f62e1f630de9622a2b6dc1add3703cfa8d7471c415ee21bd6e36e" => :mojave
    sha256 "3403d415389703649cd92acec88e85646e755a783d289b8a6beb7508ecf96f21" => :high_sierra
    sha256 "0d01c5eb1d4072a40ae8a1a2436ecd3987250152f4abc3ba76379b914929bc95" => :sierra
    sha256 "a3761d5cc8dc9fc185b5e96403106654597a1ee2dec409ca735555bf3f8b1fef" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "python@2" => :test
  end

  fails_with :clang # no OpenMP support

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j2" if ENV["CIRCLECI"]

    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
