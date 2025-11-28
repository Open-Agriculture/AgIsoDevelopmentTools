#include "StdFixedIntPrefixCheck.h"

#include "clang/AST/Type.h"
#include "clang/AST/TypeLoc.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/Lex/Lexer.h"

using namespace clang;
using namespace clang::ast_matchers;

namespace clang {
namespace tidy {
namespace stdprefix {

void StdFixedIntPrefixCheck::registerMatchers(MatchFinder *Finder) {
    Finder->addMatcher(typeLoc().bind("tloc"), this);
}

void StdFixedIntPrefixCheck::check(const MatchFinder::MatchResult &Result) {
    const auto *TL = Result.Nodes.getNodeAs<TypeLoc>("tloc");
    if (!TL || TL->isNull())
        return;

    QualType QT = TL->getType();
    const Type *T = QT.getTypePtrOrNull();
    if (!T)
        return;

    const TypedefType *TT = dyn_cast<TypedefType>(T);
    if (!TT)
        return;

    const TypedefNameDecl *TD = TT->getDecl();
    if (!TD)
        return;

    const IdentifierInfo *II = TD->getIdentifier();
    if (!II)
        return;

    StringRef Name = II->getName();

    static constexpr const char* FixedIntTypes[] = {
        "int8_t", "int16_t", "int32_t", "int64_t",
        "uint8_t", "uint16_t", "uint32_t", "uint64_t",
        "intptr_t", "uintptr_t",
        "int_fast8_t", "int_fast16_t", "int_fast32_t", "int_fast64_t",
        "uint_fast8_t", "uint_fast16_t", "uint_fast32_t", "uint_fast64_t",
        "int_least8_t", "int_least16_t", "int_least32_t", "int_least64_t",
        "uint_least8_t", "uint_least16_t", "uint_least32_t", "uint_least64_t"
    };

    bool IsFixedInt = false;
    for (auto &TName : FixedIntTypes) {
        if (Name.equals(TName)) {
            IsFixedInt = true;
            break;
        }
    }
    if (!IsFixedInt)
        return;

    const DeclContext *DC = TD->getDeclContext();
    const NamespaceDecl *NS = dyn_cast<NamespaceDecl>(DC);

    if (NS && NS->getName() == "std")
        return;

    SourceManager &SM = *Result.SourceManager;
    SourceLocation Begin = TL->getBeginLoc();
    diag(Begin, "fixed-width type should be prefixed with 'std::'")
        << FixItHint::CreateInsertion(Begin, "std::");
}

} // namespace stdprefix
} // namespace tidy
} // namespace clang
