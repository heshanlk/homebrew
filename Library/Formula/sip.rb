require 'formula'

#
# NOTE: You must also change the version in the patch below, as the upstream
# build figures out the version number from the hg checkout.
#

class Sip < Formula
  url 'http://www.riverbankcomputing.co.uk/hg/sip/archive/4.12.1.tar.gz'
  md5 '92b0bf4b2ec76da55ac45f27bd17fbe0'
  head 'http://www.riverbankcomputing.co.uk/hg/sip', :using => :hg
  homepage 'http://www.riverbankcomputing.co.uk/software/sip'

  unless ARGV.include? '--HEAD'
    def patches
      DATA
    end
  end

  def install
    system "python", "build.py", "prepare"
    system "python", "configure.py",
                              "--destdir=#{lib}/python",
                              "--bindir=#{bin}",
                              "--incdir=#{include}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    This formula won't function until you amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/python:$PYTHONPATH
    EOS
  end
end


__END__
Patch to allow the SIP build.py script to generate a reasonable version number
without the .hg directory from the Mercurial repository.

diff --git a/build.py b/build.py
index 927d7f1..fdf13a3 100755
--- a/build.py
+++ b/build.py
@@ -179,7 +179,7 @@ def _get_release():
         changelog = None
         name = os.path.basename(_RootDir)
 
-        release_suffix = "-unknown"
+        release_suffix = ""
         version = None
 
         parts = name.split('-')
@@ -192,7 +192,7 @@ def _get_release():
 
     # Format the results.
     if version is None:
-        version = (0, 1, 0)
+        version = (4, 12, 1)
 
     major, minor, micro = version
 

Another patch to remove the seemingly unnecessary framework build requirement
diff --git a/siputils.py b/siputils.py
index 57e8911..1af6152 100644
--- a/siputils.py
+++ b/siputils.py
@@ -1423,8 +1423,8 @@ class ModuleMakefile(Makefile):
             # 'real_prefix' exists if virtualenv is being used.
             dl = getattr(sys, 'real_prefix', sys.exec_prefix).split(os.sep)
 
-            if "Python.framework" not in dl:
-                error("SIP requires Python to be built as a framework")
+            # if "Python.framework" not in dl:
+                # error("SIP requires Python to be built as a framework")
 
             self.LFLAGS.append("-undefined dynamic_lookup")
 
