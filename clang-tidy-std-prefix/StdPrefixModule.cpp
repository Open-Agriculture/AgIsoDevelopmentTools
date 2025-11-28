#include "StdFixedIntPrefixCheck.h"

#include "clang-tidy/ClangTidy.h"
#include "clang-tidy/ClangTidyModule.h"
#include "clang-tidy/ClangTidyModuleRegistry.h"

using namespace clang::tidy;

namespace clang {
namespace tidy {
namespace stdprefix {

class StdPrefixModule : public ClangTidyModule {
public:
  void addCheckFactories(ClangTidyCheckFactories &Factories) override {
    Factories.registerCheck<StdFixedIntPrefixCheck>("std-prefix-fixed-int");
  }
};

} // namespace stdprefix
} // namespace tidy
} // namespace clang

static ClangTidyModuleRegistry::Add<clang::tidy::stdprefix::StdPrefixModule>
    X("std-prefix-module", "Enforce 'std::' prefix for fixed-width integer types.");

volatile int StdPrefixModuleAnchorSource = 0;
